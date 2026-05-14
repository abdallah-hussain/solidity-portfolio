# ERC-20 From Scratch

## Overview

This project is a hands-on implementation of an ERC-20 token built from scratch using Solidity.

The main goal is not only to create a token contract, but also to deeply understand:

- Why token standards exist
- The problems ERC-20 solves
- How wallets and exchanges interact with tokens
- How token balances and transfers work internally
- Why standardization is essential in blockchain ecosystems

This project focuses on learning the architecture and logic behind ERC-20 instead of simply copying existing code.

---

# What Problem Are We Trying to Solve?

To understand ERC-20 properly, we must first understand the problem that existed before token standards.

---

## Step 1 — Ethereum Originally Had No Standard Token System

Ethereum allows developers to deploy smart contracts.

This means anyone can create their own digital currency by writing a contract.

For example:

```solidity
mapping(address => uint256) balances;
```

This mapping can store how many tokens each address owns.

At this point, we already have the foundation of a cryptocurrency.

But a major problem appears immediately.

---

## Step 2 — Every Developer Could Build Tokens Differently

One developer might create a transfer function like:

```solidity
send(address to, uint256 amount)
```

Another developer might write:

```solidity
transferCoins(address receiver, uint256 value)
```

Another might use:

```solidity
moveTokens(address user, uint256 quantity)
```

All of these functions may perform the same task, but they use different names and structures.

This creates inconsistency.

---

## Step 3 — Wallets Cannot Understand Every Token Automatically

A wallet application like MetaMask needs to know:

- How to check balances
- How to transfer tokens
- How to display token information

But if every token uses different function names and different logic, wallets must write custom code for every single token.

That becomes impossible at scale.

---

## Step 4 — Exchanges Face the Same Problem

Decentralized exchanges and applications also need consistent ways to:

- Read balances
- Transfer tokens
- Approve spending
- Interact with smart contracts

Without standardization:

- Every token behaves differently
- Integrations become expensive
- Compatibility breaks
- The ecosystem becomes fragmented

---

## Step 5 — Ethereum Needed a Shared Rulebook

The Ethereum community realized that all fungible tokens should follow the same structure.

So they created a standard that defines:

- Required functions
- Expected behavior
- Common interaction methods

This standard became ERC-20.

---

# What Is ERC-20?

ERC-20 is a technical standard for fungible tokens on Ethereum.

- ERC = Ethereum Request for Comment
- 20 = Proposal number 20

ERC-20 defines a common set of rules that tokens must follow.

Because of this standard:

- Wallets can support tokens automatically
- Exchanges can list tokens easily
- Smart contracts can interact consistently
- Developers can build interoperable applications

---

# What Does “Fungible” Mean?

A fungible asset means every unit is interchangeable and equal in value.

Example:

- 1 USDT = another 1 USDT
- 1 USDC = another 1 USDC

Just like:

- One dollar bill has the same value as another dollar bill

This is different from NFTs, where every asset is unique.

---

# Core ERC-20 Functions

The ERC-20 standard defines several important functions.

## 1. balanceOf()

Checks how many tokens an address owns.

```solidity
balanceOf(address account)
```

---

## 2. transfer()

Transfers tokens from one account to another.

```solidity
transfer(address to, uint256 amount)
```

---

## 3. approve()

Allows another address or smart contract to spend tokens on your behalf.

```solidity
approve(address spender, uint256 amount)
```

---

## 4. allowance()

Checks how many tokens a spender is allowed to use.

```solidity
allowance(address owner, address spender)
```

---

## 5. transferFrom()

Transfers tokens using a previously approved allowance.

```solidity
transferFrom(address from, address to, uint256 amount)
```

---

# Why approve() and transferFrom() Exist

These functions are extremely important for decentralized applications.

Example:

A decentralized exchange cannot directly access your wallet.

Instead:

1. You approve the exchange to spend a certain amount
2. The exchange calls transferFrom()
3. The transfer happens within the approved limit

This creates a permission-based system.

---

# Project Goals

This project aims to build an ERC-20 token step by step while understanding:

- State variables
- Mappings
- Token balances
- Transfers
- Allowances
- Events
- Security considerations
- Standardized interfaces
- Smart contract interoperability

The focus is educational and architectural.

---

# Technologies Used

- Solidity
- Ethereum Virtual Machine (EVM)
- Remix IDE or Foundry/Hardhat

---

# Learning Objectives

By completing this project, you should understand:

- Why standards matter in software systems
- How ERC-20 created interoperability in Ethereum
- How wallets and dApps interact with tokens
- How token transfers are implemented internally
- How approvals and delegated spending work
- How smart contracts communicate through standardized interfaces

---

# Final Intuition

Before ERC-20:

```text
Every token spoke a different language.
```

After ERC-20:

```text
All tokens follow the same communication rules.
```

That standardization is what allowed the Ethereum token ecosystem to scale.

