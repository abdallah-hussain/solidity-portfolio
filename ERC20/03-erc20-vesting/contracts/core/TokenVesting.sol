// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "../interfaces/IERC20.sol";

// ─────────────────────────────────────────────────────────────────
//  TokenVesting
//
//  Locks ERC-20 tokens for a beneficiary and releases them
//  gradually over a defined period (linear vesting).
//
//  Key concepts:
//  - cliff    → minimum wait time before ANY tokens are released
//  - duration → total time period over which tokens unlock
//  - linear   → tokens unlock proportionally every second after cliff
// ─────────────────────────────────────────────────────────────────

contract TokenVesting {

    // ── State Variables ───────────────────────────────────────────

    IERC20 public immutable token;

    // The address that controls this contract.
    address public owner;

    // Reentrancy lock. true = a function is currently executing.
    bool private locked;


    // Represents a single vesting agreement for one beneficiary.
    struct VestingSchedule {
        address beneficiary; // address that will receive the tokens
        uint256 totalAmount; // total tokens locked in this schedule
        uint256 start;       // timestamp when vesting begins (set at creation)
        uint256 duration;    // total vesting period in seconds
        uint256 cliff;       // minimum seconds before any tokens unlock
        uint256 released;    // tokens already claimed by the beneficiary
    }

    // One vesting schedule per beneficiary address.
    // A beneficiary cannot have two active vestings simultaneously.
    mapping(address => VestingSchedule) public vestings;

    // ── Custom Errors ─────────────────────────────────────────────
    // Custom errors cost less gas than require() with strings.
    error InvalidBeneficiary();  // beneficiary is the zero address
    error InvalidAddress();      // a general zero address check (non-beneficiary)
    error InvalidAmount();       // amount is zero
    error InvalidDuration();     // duration is zero
    error VestingAlreadyExists();// beneficiary already has an active vesting
    error VestingNotFound();     // no vesting exists for this beneficiary
    error TransferFailed();      // ERC-20 transfer returned false
    error NothingToClaim();      // releasable amount is currently zero
    error Unauthorized();        // caller is not the owner

    // ── Modifiers ─────────────────────────────────────────────────

    // Restricts a function to the contract owner only.
    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    // Prevents reentrancy attacks.
    // Sets locked = true before execution, false after.
    modifier nonReentrant() {
        if (locked) revert();
        locked = true;
        _;
        locked = false;
    }

    // ── Events ────────────────────────────────────────────────────

    // Emitted when a new vesting schedule is created.
    event VestingCreated(
        address indexed beneficiary, // who will receive the tokens
        uint256 amount,              // total tokens locked
        uint256 duration             // vesting period in seconds
    );

    // Emitted when a beneficiary successfully claims unlocked tokens.
    event TokenClaimed(
        address indexed beneficiary, // who received the tokens
        uint256 amount               // how many tokens were released
    );

    // Emitted when the owner cancels a vesting schedule.
    event VestingCancelled(
        address indexed beneficiary, // whose vesting was cancelled
        uint256 claimableSent,       // tokens sent to beneficiary (already earned)
        uint256 refunded             // unvested tokens returned to owner
    );

    // Emitted when the owner withdraws tokens in an emergency.
    event EmergencyWithdraw(uint256 amount);

    // Emitted when ownership of the contract changes.
    event OwnershipTransferred(
        address indexed oldOwner,
        address indexed newOwner
    );

    // ── Constructor ───────────────────────────────────────────────
    // Sets the token this contract will vest and assigns the deployer as owner.
    // tokenAddress must be a valid ERC-20 contract address.
    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
        owner = msg.sender;
    }

    // ── Core Functions ────────────────────────────────────────────

    // Creates a new vesting schedule for a beneficiary.
    //
    // The caller must have approved this contract to spend `amount` tokens
    // before calling this function (via token.approve()).
    //
    // Parameters:
    // - beneficiary → address that will claim the tokens over time
    // - amount      → total tokens to lock (in raw units, e.g. 1000 * 10^18)
    // - duration    → total vesting period in seconds
    // - cliff       → seconds before any tokens become claimable
    //
    // Checks:
    // - beneficiary is not zero address
    // - amount is greater than zero
    // - duration is greater than zero
    // - beneficiary does not already have an active vesting
    function createVesting(
        address beneficiary,
        uint256 amount,
        uint256 duration,
        uint256 cliff
    ) external onlyOwner {
        // Validate all inputs before touching any state
        if (beneficiary == address(0)) revert InvalidBeneficiary();
        if (amount == 0)               revert InvalidAmount();
        if (duration == 0)             revert InvalidDuration();

        // One active vesting per beneficiary at a time
        if (vestings[beneficiary].totalAmount != 0) revert VestingAlreadyExists();

        // Write the vesting schedule to storage
        vestings[beneficiary] = VestingSchedule({
            beneficiary: beneficiary,
            totalAmount: amount,
            start:       block.timestamp, // vesting starts now
            duration:    duration,
            cliff:       cliff,
            released:    0                // nothing claimed yet
        });

        // Pull tokens from the caller into this contract.
        bool success = token.transferFrom(msg.sender, address(this), amount);
        if (!success) revert TransferFailed();

        emit VestingCreated(beneficiary, amount, duration);
    }

    // Calculates how many tokens have unlocked for a beneficiary so far.
    //
    // Logic:
    // - Before cliff ends  → 0 tokens vested
    // - After full duration → all tokens vested
    // - In between         → proportional to time elapsed
   
    function vestedAmount(address beneficiary) public view returns (uint256) {
        VestingSchedule memory vesting = vestings[beneficiary];

        // Cliff has not passed yet — nothing is unlocked
        if (block.timestamp < vesting.start + vesting.cliff) {
            return 0;
        }

        // Full duration has passed — everything is unlocked
        if (block.timestamp >= vesting.start + vesting.duration) {
            return vesting.totalAmount;
        }

        // Linear vesting: unlock proportionally to time elapsed
        // elapsed / duration = fraction of tokens unlocked
        // Multiply first to avoid precision loss from integer division
        uint256 elapsed = block.timestamp - vesting.start;
        return (vesting.totalAmount * elapsed) / vesting.duration;
    }

    // Returns how many tokens a beneficiary can claim right now.

    function releasableAmount(address beneficiary) public view returns (uint256) {
        return vestedAmount(beneficiary) - vestings[beneficiary].released;
    }

    // Allows a beneficiary to claim their currently unlocked tokens.
    //
    // Flow:
    // 1. Calculate how many tokens are claimable right now
    // 2. Revert if nothing is available
    // 3. Update released counter BEFORE transferring (checks-effects-interactions)
    // 4. Transfer tokens to caller
    // 5. Emit event
    //
    // nonReentrant prevents a malicious token contract from calling
    // claim() again before the first execution finishes.
    function claim() external nonReentrant {
        // Step 1 — how much can the caller claim right now?
        uint256 amount = releasableAmount(msg.sender);

        // Step 2 — nothing available, revert early
        if (amount == 0) revert NothingToClaim();

        // Step 3 — update state BEFORE the transfer
        // If transfer is done first, a reentrant call could claim again
        // before released is updated.
        vestings[msg.sender].released += amount;

        // Step 4 — transfer unlocked tokens to the beneficiary
        bool success = token.transfer(msg.sender, amount);
        if (!success) revert TransferFailed();

        // Step 5 — log the claim
        emit TokenClaimed(msg.sender, amount);
    }

    // cancellation logic:
    // - Tokens already vested (earned) are sent to the beneficiary first
    // - Only the unvested remainder is returned to the owner
    // This prevents the owner from cancelling a vesting and taking

    function cancelVesting(address beneficiary)
        external
        onlyOwner
        nonReentrant
    {
        VestingSchedule storage vesting = vestings[beneficiary];

        // Ensure a vesting actually exists for this address
        if (vesting.totalAmount == 0) revert VestingNotFound();

        // Calculate what the beneficiary has earned but not yet claimed
        uint256 vested     = vestedAmount(beneficiary);
        uint256 claimable  = vested - vesting.released;

        // Calculate what has not vested yet — this goes back to the owner
        uint256 refundable = vesting.totalAmount - vested;

        // Delete the schedule before any transfers (checks-effects-interactions)
        delete vestings[beneficiary];

        // Send earned but unclaimed tokens to the beneficiary
        if (claimable > 0) {
            bool successBeneficiary = token.transfer(beneficiary, claimable);
            if (!successBeneficiary) revert TransferFailed();
        }

        // Return unvested tokens to the owner
        if (refundable > 0) {
            bool successOwner = token.transfer(owner, refundable);
            if (!successOwner) revert TransferFailed();
        }

        emit VestingCancelled(beneficiary, claimable, refundable);
    }

    // Allows the owner to withdraw any tokens held by this contract.

    function emergencyWithdraw(uint256 amount)
        external
        onlyOwner
        nonReentrant
    {
        bool success = token.transfer(owner, amount);
        if (!success) revert TransferFailed();

        emit EmergencyWithdraw(amount);
    }

    // Transfers contract ownership to a new address.
    // The new owner immediately gains all owner privileges.

    function transferOwnership(address newOwner)
        external
        onlyOwner
    {
        // Transferring to zero address would permanently lock the contract
        if (newOwner == address(0)) revert InvalidAddress();

        emit OwnershipTransferred(owner, newOwner);

        // Update owner after emitting event so old owner is still in the log
        owner = newOwner;
    }
}
