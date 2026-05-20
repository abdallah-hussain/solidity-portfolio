// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import OpenZeppelin ERC20 implementation.
// This provides the full ERC-20 standard functionality including:
// - balances
// - transfers
// - allowances
// - events
// - minting/burning internals
import { ERC20 } from "@openzeppelin/contracts@5.0.0/token/ERC20/ERC20.sol";

// Import OpenZeppelin AccessControl system.
// This provides role-based permissions management.
import { AccessControl } from "@openzeppelin/contracts@5.0.0/access/AccessControl.sol";

// ERC-20 Pausable extension.
// Adds the ability to freeze all token transfers in an emergency.
import { ERC20Pausable } from "@openzeppelin/contracts@5.0.0/token/ERC20/extensions/ERC20Pausable.sol";

// ERC-20 Burnable extension.
// Adds burn() and burnFrom() to the contract automatically.
// burn()     → caller destroys their own tokens.
// burnFrom() → caller destroys tokens from another address using allowance.
import { ERC20Burnable } from "@openzeppelin/contracts@5.0.0/token/ERC20/extensions/ERC20Burnable.sol";

// MyERC20 inherits functionality from:
// 1. ERC20         -> token standard logic
// 2. AccessControl -> role/permission management


/////Contract Declaration /////////

//// ERC20Pausable  → pausable transfer logic (extends ERC20 internally)
// ERC20Burnable  → burn and burnFrom functions
// AccessControl  → role management system


contract MyERC20 is ERC20Pausable, ERC20Burnable, AccessControl {
    // Create a unique identifier for the MINTER_ROLE.
    // Accounts with this role are allowed to mint new tokens.
    // keccak256 generates a fixed unique hash.
   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // PAUSER_ROLE — accounts with this role can pause and unpause
    // all token transfers across the entire contract.
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");  


    // Contract constructor.
    //
    // ERC20("My Token", "MTK")
    // initializes the parent ERC20 contract with:
    // - token name
    // - token symbol
    constructor() ERC20("My Token", "MTK") {

        // msg.sender during deployment = deployer address.
        // After deployment, msg.sender (the deployer) holds:
        // - DEFAULT_ADMIN_ROLE → can manage all roles
        // - MINTER_ROLE        → can mint new tokens
        // - PAUSER_ROLE        → can pause/unpause transfers        

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        // Grant deployer permission to mint tokens.
        _grantRole(MINTER_ROLE, msg.sender);    

        // Grant the deployer permission to pause and unpause transfers.
        _grantRole(PAUSER_ROLE, msg.sender);
    }

    /// Mint new tokens ///
    
    // onlyRole(MINTER_ROLE):
    // Restricts access so only authorized minters
    // can create new tokens.
    //
    // Parameters:
    // - to     : recipient address
    // - amount : number of tokens to mint
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        // Internal OpenZeppelin ERC20 mint function.
        //
        // _mint():
        // 1. increases totalSupply
        // 2. increases recipient balance
        // 3. emits Transfer(address(0), to, amount)
        //
        // address(0) represents newly created tokens.
        _mint(to, amount);

    }


    // PAUSE //

    // Freezes all token transfers across the entire contract.
    // Access: restricted to accounts holding PAUSER_ROLE.

    // Internally calls OpenZeppelin's _pause() which:
    // 1. sets the internal paused state to true
    // 2. emits a Paused(account) event

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }
    
    //   UNPAUSE//
    // Restores all token transfers after a pause.
    // Internally calls OpenZeppelin's _unpause() which:
    // 1. sets the internal paused state to false
    // 2. emits an Unpaused(account) event
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }


    // BURN //   
    // burn() and burnFrom() are inherited automatically from
    // ERC20Burnable. No need to write them manually.
    //
    // burn(amount):
    // - caller destroys `amount` of their own tokens
    // - decreases their balance and totalSupply
    // - emits Transfer(caller, address(0), amount)
    // - address(0) signals tokens leaving circulation
    //
    // burnFrom(from, amount):
    // - caller destroys `amount` from another address
    // - requires the caller to have sufficient allowance from `from`
    // - decrements the allowance before burning
    // - useful for contracts that manage tokens on behalf of users


    // INTERNAL OVERRIDE — _update() //

    // Required override to resolve a conflict between
    // ERC20 and ERC20Pausable.
    // This ensures transfers are blocked when the contract is paused.
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}
