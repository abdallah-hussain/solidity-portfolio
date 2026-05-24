# ERC-20 Implementations

A structured smart contract learning journey focused on deeply understanding the ERC-20 ecosystem by building progressively from fundamentals to real-world token systems.

The repository follows a layered learning approach:

```text
Build Fundamentals
↓
Understand Internals
↓
Use Production Patterns
↓
Design Real Token Systems
```

---

# Goal

Most developers use ERC-20 contracts without fully understanding:

- how balances are stored
- how token transfers actually work
- how approvals and allowances operate
- how production libraries abstract complexity
- how token distribution systems are implemented

This repository solves that by rebuilding the ecosystem step-by-step before relying on abstraction layers.

The focus is not only writing contracts —

but understanding why they work.

---

# Projects

---

## 01 · ERC-20 From Scratch

Zero dependencies. Full manual implementation.

This project implements the ERC-20 standard completely from first principles.

### Key Features

- Token state management (`balances`)
- Allowance system (`approve / transferFrom`)
- Transfer logic with validation
- Event emission (`Transfer / Approval`)
- Full ERC-20 interface implementation

### Why It Matters

This removes the black-box effect.

Every line of logic becomes visible, traceable, and understandable.

### What You Learn

- Token architecture
- State management
- Contract interaction
- ERC-20 internal mechanics
- Standardization principles

→ View Project

---

## 02 · ERC-20 Using OpenZeppelin

Production-ready implementation using OpenZeppelin Contracts.

This project rebuilds the same token using industry-standard libraries and patterns.

### Key Features

- OpenZeppelin ERC20 base contract
- Minting & burning extensions
- Access control systems
- Cleaner architecture
- Production-oriented implementation

### Why It Matters

After understanding the internals, OpenZeppelin becomes a tool—not a mystery.

### What You Learn

- Library-based development
- Inheritance architecture
- Production contract design
- Security-oriented abstractions

→ View Project

---

## 03 · ERC-20 Vesting

Time-based token distribution with secure on-chain enforcement.

This project extends ERC-20 usage beyond token creation and explores how real blockchain projects manage token distribution over time.

Instead of sending tokens immediately, tokens are locked inside a vesting contract and gradually released according to predefined schedules.

### Key Features

- Linear token vesting
- Cliff-based unlock periods
- Claimable token calculations
- Secure token release flow
- Vesting cancellation logic
- Reentrancy protection
- Ownership management
- Emergency recovery functions

### Why It Matters

Building ERC-20 teaches how tokens work.

Building vesting teaches how tokens are controlled.

This introduces real-world mechanisms used in:

- token launches
- startup allocations
- employee compensation
- investor unlock schedules
- treasury management

### What You Learn

- Time-based smart contract design
- Vesting architecture
- Secure token release patterns
- Access control
- State transitions
- Production Solidity practices

→ View Project

---

# Learning Approach

The repository follows one strict principle:

```text
Understand the mechanism first.
Then abstract it.
Then apply it.
```

This prevents dependency-first development and builds deeper engineering intuition.

---

# Repository Structure

```text
ERC20/
│
├── 01-erc20-from-scratch/
│
├── 02-erc20-openzeppelin/
│
├── 03-erc20-vesting/
│
└── README.md
```

---

# Key Takeaway

Each project answers a different question:

```text
01 → How does ERC-20 work?

02 → How do professionals build ERC-20?

03 → How are tokens controlled after creation?
```

Together they create a complete understanding of ERC-20 systems.

```text
Build
↓
Understand
↓
Abstract
↓
Scale
```