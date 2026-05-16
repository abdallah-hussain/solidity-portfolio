# ERC-20 High-Level Architecture

## Overview

An ERC-20 token system is not only a smart contract.

It is a complete interaction between multiple layers working together:

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

Each layer has a specific responsibility.

Understanding how these layers connect is essential for understanding blockchain development.

---

# System Layers

## 1. User Layer

The user is the person interacting with the application.

### Example Actions

* Send tokens
* Receive tokens
* Approve spending
* Check balances

### Example

```text
Alice sends 100 MTK to Bob
```

The user cannot directly interact with Ethereum.

The user needs:

* a frontend application
* a wallet

---

## 2. Frontend Layer (Website / dApp)

The frontend is the application interface.

### Common Technologies

* HTML
* CSS
* JavaScript
* React
* Next.js

### Responsibilities

* Display balances
* Show buttons and forms
* Send requests to smart contracts
* Display blockchain data

### Example UI

```text
[ Send Tokens ]
```

When the user clicks a button, the frontend prepares a request:

```javascript
contract.transfer(bob, 100)
```

However, the frontend alone cannot execute blockchain transactions.

Why?

Because blockchain transactions require cryptographic authorization.

---

## 3. Wallet Layer (MetaMask)

The wallet acts as the user's blockchain identity system.

### Examples

* MetaMask
* Rabby
* Trust Wallet

### Responsibilities

* Store private keys
* Sign transactions
* Connect users to blockchain applications
* Approve or reject actions

> Important:
>
> Wallets do NOT store tokens.
>
> Tokens exist on the blockchain inside smart contracts.

The wallet only:

* proves ownership
* authorizes actions
* signs transactions

---

# Frontend vs Wallet

| Frontend                  | Wallet                          |
| ------------------------- | ------------------------------- |
| User interface            | User identity system            |
| Displays data             | Signs transactions              |
| Cannot spend funds        | Can authorize spending          |
| Handles interaction logic | Handles cryptographic ownership |

---

## Frontend Perspective

The frontend says:

```text
"Here is an action you can perform."
```

---

## Wallet Perspective

The wallet says:

```text
"I approve or reject this action."
```

---

## 4. Ethereum Blockchain

Ethereum stores:

* smart contracts
* balances
* transaction history
* blockchain state

Once transactions are confirmed, the data becomes:

* decentralized
* transparent
* difficult to modify

---

## 5. EVM (Ethereum Virtual Machine)

The EVM is Ethereum's execution engine.

### Responsibilities

* Execute smart contract code
* Process transactions
* Update blockchain state

### Mental Model

```text
Ethereum's decentralized computer
```

---

## 6. ERC-20 Smart Contract

The smart contract contains the actual token logic.

### Responsibilities

* Track balances
* Transfer tokens
* Manage approvals
* Store total supply
* Emit events

The ERC-20 contract is the core of the token system.

Everything else interacts with it.

---

# Full Transaction Lifecycle

Example:

```text
Alice sends 100 MTK to Bob
```

---

## Step 1 — User Interaction

Alice clicks:

```text
Send
```

inside the frontend application.

---

## Step 2 — Frontend Creates Request

The frontend prepares:

```javascript
contract.transfer(bob, 100)
```

---

## Step 3 — Wallet Authorization

MetaMask appears and asks:

```text
Do you approve this transaction?
```

Alice confirms.

The wallet signs the transaction using Alice's private key.

---

## Step 4 — Transaction Sent to Ethereum

The signed transaction is broadcast to the Ethereum network.

---

## Step 5 — EVM Executes Contract Code

The EVM executes:

```solidity
transfer(bob, 100)
```

inside the ERC-20 contract.

---

## Step 6 — Contract Updates Balances

### Before

```text
Alice = 1000
Bob = 200
```

### After

```text
Alice = 900
Bob = 300
```

---

## Step 7 — Event Emitted

The contract emits a `Transfer` event.

Wallets and applications monitor these events to update their interfaces.

---

# Final Intuition

An ERC-20 ecosystem is a collaboration between:

* users
* frontends
* wallets
* Ethereum
* the EVM
* smart contracts

The smart contract is the center of the system.

Everything else exists to:

* interact with it
* authorize actions
* display information



