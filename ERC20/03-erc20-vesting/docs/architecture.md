# Token Vesting — Architecture

## Overview

A token vesting system is more than a simple smart contract.

It is a coordination layer between:

- the owner funding the vesting
- the beneficiary receiving tokens over time
- the ERC-20 token being locked and released

The smart contract automatically enforces all vesting rules.

---

# System Architecture

```text
Owner
  ↓
createVesting()
  ↓
TokenVesting Contract
  ↓
claim()
  ↓
ERC-20 Token Contract
  ↓
Beneficiary
```

---

# 1. Owner Layer

The owner deploys and manages the vesting system.

## Responsibilities

- Create vesting schedules
- Cancel active vestings
- Execute emergency withdrawals
- Transfer ownership

## Security Constraint

The owner cannot reclaim tokens that have already vested to beneficiaries.

This rule is enforced entirely by contract logic.

---

# 2. Beneficiary Layer

The beneficiary receives tokens according to a vesting schedule.

## Responsibilities

- Wait for tokens to vest
- Claim unlocked tokens
- Monitor vesting progress

## Security Constraint

Beneficiaries can only withdraw tokens that have already vested.

The contract calculates claimable amounts automatically using `block.timestamp`.

---

# 3. TokenVesting Contract

The vesting contract acts as the core coordination layer.

## Responsibilities

- Securely hold locked tokens
- Store vesting schedules
- Calculate vested amounts
- Release claimable tokens
- Enforce authorization rules

---

# Storage Model

```solidity
mapping(address => VestingSchedule) vestings;
```

Each beneficiary is associated with a single vesting schedule.

---

# VestingSchedule Structure

```solidity
struct VestingSchedule {
    address beneficiary;
    uint256 totalAmount;
    uint256 start;
    uint256 duration;
    uint256 cliff;
    uint256 released;
}
```

---

# Field Descriptions

| Field | Description |
|------|-------------|
| beneficiary | Vesting recipient |
| totalAmount | Total locked allocation |
| start | Vesting start timestamp |
| duration | Full vesting duration |
| cliff | Initial lock period |
| released | Amount already claimed |

The `released` field tracks previously claimed tokens and prevents double withdrawals.

---

# ERC-20 Integration

The contract interacts with tokens through the standard `IERC20` interface.

## Functions Used

```solidity
transferFrom()
transfer()
```

### Purpose

- `transferFrom()` locks tokens into the contract
- `transfer()` releases vested tokens to beneficiaries

The vesting contract remains token-agnostic and only depends on the ERC-20 standard interface.

---

# Access Control Model

```text
Owner
├── createVesting()
├── cancelVesting()
├── emergencyWithdraw()
└── transferOwnership()

Beneficiary
└── claim()

Public Read Functions
├── vestedAmount()
└── releasableAmount()
```

---

# Token Flow

## Vesting Creation

```text
Owner Wallet
    │
    └── transferFrom()
            ↓
    TokenVesting Contract
```

Tokens are transferred from the owner into the vesting contract and locked.

---

## Claim Process

```text
TokenVesting Contract
            │
            └── transfer()
                    ↓   
            Beneficiary Wallet
```

Only vested tokens can be released.

---

## Vesting Cancellation

```text
TokenVesting Contract
│
├── vested tokens   → Beneficiary
└── unvested tokens → Owner
```

The contract automatically calculates the distribution split during cancellation.

---

# Time Model

All vesting calculations use `block.timestamp`.

```text
start     = vesting start timestamp
cliff     = minimum lock duration
duration  = total vesting duration
elapsed   = current time - start
```

---

# Unlock Formula

```text
if now < start + cliff
    vested = 0

if now >= start + duration
    vested = totalAmount

otherwise
    vested = (totalAmount × elapsed) / duration
```

---

# Security Model

## Reentrancy Protection

Sensitive token-transfer operations use:

- `nonReentrant`
- checks-effects-interactions

State changes always occur before external token transfers.

---

## Fair Cancellation

```text
vested     = vestedAmount()
claimable  = vested - released
refundable = totalAmount - vested
```

- vested tokens remain claimable by the beneficiary
- unvested tokens are refunded to the owner

The owner cannot confiscate earned allocations.

---

# Final Mental Model

```text
TokenVesting Contract = Time-Locked Vault

Owner deposits tokens
Time unlocks them gradually
Beneficiary claims vested tokens
Contract enforces the rules automatically
```