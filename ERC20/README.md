# ERC-20 Implementations

A structured smart contract learning journey focused on deeply understanding the ERC-20 standard by building it in two stages:

1. From raw implementation (no libraries)
2. Using production-grade OpenZeppelin contracts

---

## Goal

Most developers use ERC-20 contracts without understanding their internal mechanics.

This repository solves that by rebuilding the standard from the ground up before using any abstraction layer.

The focus is not just writing contracts — but understanding how and why they work.

---

## Projects

### 01 · ERC-20 From Scratch

**Zero dependencies. Full manual implementation.**

This project implements the ERC-20 standard completely from first principles.

#### Key Features:
- Token state management (balances mapping)
- Allowance system (approve / transferFrom)
- Transfer logic with safety checks
- Event emission (Transfer / Approval)
- Full adherence to ERC-20 interface

#### Why it matters:
This removes the “black box” effect. Every line of logic is visible, traceable, and understood.

→ [View Project](./01-erc20-from-scratch/)

---

### 02 · ERC-20 Using OpenZeppelin

**Production-ready implementation using OpenZeppelin Contracts v5**

This project rebuilds the same token using industry-standard libraries.

#### Key Features:
- OpenZeppelin ERC20 base contract
- Minting & burning extensions
- Access control patterns (Ownable / roles)
- Safer and audited implementation
- Cleaner, production-focused architecture

#### Why it matters:
After understanding the internals, OpenZeppelin becomes a tool—not a mystery.

→ [View Project](./02-openzeppelin-erc20/)

---

## Learning Approach

The structure follows a strict rule:

> Understand the mechanism first. Then abstract it.

This avoids the common problem where developers rely on libraries without understanding failure points or internal behavior.

---

## Key Takeaway

Building from scratch first creates intuition.

Using OpenZeppelin afterward creates production readiness.

Together, they form a complete understanding of ERC-20 systems.

---
