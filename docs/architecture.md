# ERC-20 High-Level Architecture

## Overview

An ERC-20 token system is not just a smart contract.  
It is a full ecosystem where multiple layers work together to enable token ownership, transfers, and approvals.

The smart contract is the core, but users never interact with it directly. Instead, they go through applications and wallets.

---

# System Architecture

```text
User
  ↓
Frontend (dApp / Website)
  ↓
Wallet (MetaMask)
  ↓
Ethereum Blockchain
  ↓
EVM (Ethereum Virtual Machine)
  ↓
ERC-20 Smart Contract

````


---

# 1. User Layer

The user is the person performing actions such as:
- Sending tokens
- Receiving tokens
- Approving spending
- Checking balances

The user does NOT interact directly with blockchain systems.

---

# 2. Frontend Layer (dApp / Website)

The frontend is the interface between user and blockchain.

## Responsibilities:
- Display token balances
- Provide buttons and forms
- Build transaction requests
- Call smart contract functions
- Show transaction results

## Important limitation:
The frontend cannot execute transactions alone.

It can only request actions.

---

# 3. Wallet Layer (MetaMask)

The wallet is the user's identity and security layer.

## Responsibilities:
- Store private keys securely
- Sign transactions cryptographically
- Confirm or reject requests from dApps
- Represent the user's blockchain identity

## Key idea:
Wallets do NOT store tokens.

Tokens exist on the blockchain, not inside the wallet.

---

# 4. Ethereum Network

Ethereum is a decentralized network that:
- Stores smart contracts
- Maintains global state (balances, allowances)
- Processes transactions
- Ensures consensus across nodes

Once data is written here, it becomes immutable (hard to change).

---

# 5. EVM (Ethereum Virtual Machine)

The EVM is the execution engine of Ethereum.

## Responsibilities:
- Runs smart contract code
- Processes function calls
- Updates blockchain state
- Ensures deterministic execution

Think of it as a global decentralized computer.

---

# 6. ERC-20 Smart Contract

This is the core logic layer of the token system.

## It is responsible for:
- Tracking balances
- Moving tokens between accounts
- Managing allowances (permissions)
- Controlling total supply
- Emitting events for tracking

Everything else depends on this contract.

---

# Transaction Lifecycle (Step-by-Step)

Example: Alice sends 100 tokens to Bob

## Step 1 — User Action
Alice clicks "Send 100 tokens" in the frontend.

## Step 2 — Frontend Request
Frontend builds a transaction:
- function: transfer()
- parameters: Bob, 100

## Step 3 — Wallet Confirmation
MetaMask prompts Alice:
- "Do you approve this transaction?"

Alice signs it.

## Step 4 — Network Submission
Signed transaction is broadcast to Ethereum network.

## Step 5 — Execution (EVM)
The EVM executes the ERC-20 contract function.

## Step 6 — State Update
Balances are updated:
- Alice decreases
- Bob increases

## Step 7 — Event Emission
A Transfer event is emitted for tracking.

---

# Final Mental Model

ERC-20 systems work like this:

- User initiates action
- Frontend prepares request
- Wallet authorizes it
- Blockchain executes it
- Smart contract defines the rules

