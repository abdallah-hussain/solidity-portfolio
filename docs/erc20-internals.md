# ERC-20 Internal Design

## Overview

An ERC-20 token is a smart contract that behaves like a decentralized accounting system.

It is responsible for tracking:
- token ownership
- balances
- permissions (allowances)
- total supply
- transfer operations
- system events

Internally, everything is represented using simple storage variables and mappings.

---

# Core Internal Structure


```text
ERC20 Contract
│
├── Metadata
├── Supply Tracking
├── Balance Storage
├── Transfer Logic
├── Allowance System
├── Events
└── Security Checks
```

---

# 1. Metadata Layer

The metadata layer describes the token.

### Example

```solidity
string public name;
string public symbol;
uint8 public decimals;
```

---

## Purpose

Metadata helps wallets and applications display token information.

### Example

```text
Name: MyToken
Symbol: MTK
Decimals: 18
```

Without metadata, wallets would only display contract addresses.

---

# 2. Total Supply

```solidity
uint256 public totalSupply;
```

This variable tracks:

```text
How many tokens exist globally
```

### Example

```text
1,000,000 MTK
```

---

# 3. Balance Storage

This is the core of the ERC-20 system.

```solidity
mapping(address => uint256) balances;
```

This mapping stores:

```text
Wallet Address → Token Balance
```

### Example

```text
Alice → 1000
Bob → 500
Charlie → 50
```

> Important:
>
> Tokens are not physical objects.
>
> They are numbers stored in blockchain state.

---

# 4. Transfer System

The transfer system moves balances between users.

### Main Function

```solidity
transfer(address to, uint256 amount)
```

---

## Internal Logic

```solidity
balances[msg.sender] -= amount;
balances[to] += amount;
```

### Responsibilities

* Validate balances
* Subtract sender balance
* Add receiver balance
* Emit transfer event

---

# 5. Allowance System

The allowance system enables delegated spending.

Meaning:

```text
Another address or smart contract can spend tokens with permission.
```

This system is heavily used in:

* decentralized exchanges
* staking systems
* DeFi protocols

---

## approve()

```solidity
approve(address spender, uint256 amount)
```

Meaning:

```text
"I allow this address to spend up to this amount."
```

---

## allowance()

```solidity
allowance(address owner, address spender)
```

Checks the approved amount.

---

## transferFrom()

```solidity
transferFrom(address from, address to, uint256 amount)
```

Transfers tokens using a previously approved allowance.

---

# Nested Mapping Structure

The allowance system internally uses:

```solidity
mapping(address => mapping(address => uint256))
```

Meaning:

```text
Owner → Spender → Allowed Amount
```

### Example

```text
Alice → Uniswap → 500
```

Meaning:

```text
Uniswap can spend up to 500 of Alice's tokens
```

---

# 6. Events System

Events create blockchain logs.

### Example

```solidity
event Transfer(address from, address to, uint256 amount);
```

### Events Are Used By

* wallets
* frontends
* block explorers

Without events, applications cannot efficiently track token activity.

---

# 7. Security Checks

Security checks protect token integrity.

### Example

```solidity
require(balance >= amount);
```

These validations prevent:

* overspending
* invalid transfers
* unauthorized spending

---

# Final Intuition

ERC-20 is fundamentally:

```text
A standardized accounting and permission system on Ethereum
```
