# ERC-20 Project Diagrams & Flowcharts



## ERC-20 High-Level Architecture

```text
+-------------------+
|      User         |
| (Wallet Owner)    |
+---------+---------+
          |
          | signs transaction
          v
+-------------------+
| Wallet (MetaMask) |
+---------+---------+
          |
          | sends transaction
          v
+-------------------+
| Ethereum Network  |
|      (EVM)        |
+---------+---------+
          |
          | executes smart contract
          v
+-------------------+
|   ERC20 Contract  |
+---------+---------+
          |
          |
          +---------------------+
          |                     |
          v                     v
+----------------+   +-------------------+
| Contract State |   | Event Logs        |
| balances       |   | Transfer Event    |
| allowances     |   | Approval Event    |
| totalSupply    |   +-------------------+
+----------------+
```

---

## ERC-20 Internal Architecture

```text
ERC20 Contract
│
├── Metadata
│   ├── name
│   ├── symbol
│   └── decimals
│
├── Supply Tracking
│   └── totalSupply
│
├── Balance Storage
│   └── mapping(address => uint256) balanceOf
│
├── Allowance System
│   └── mapping(address => mapping(address => uint256)) allowance
│
├── Core Functions
│   ├── transfer()
│   ├── approve()
│   └── transferFrom()
│
├── Internal Functions
│   ├── _mint()
│   └── _burn()
│
└── Events
    ├── Transfer
    └── Approval
```

---

## Complete Project Structure

```text
ERC20-Project/
│
├── contracts/
│   │
│   ├── ERC20.sol
│   │
│   ├── interfaces/
│   │   └── IERC20.sol
│   │
│   └── tokens/
│       └── MyToken.sol
│
└── README.md
```

---

## Inheritance Relationship Diagram

```text
+----------------+
|   IERC20.sol   |
|  (Interface)   |
+--------+-------+
         |
         | inherited by
         v
+----------------+
|    ERC20.sol   |
| Implementation |
+--------+-------+
         |
         | inherited by
         v
+----------------+
|  MyToken.sol   |
| Actual Token   |
+----------------+
```

---

## ERC-20 Deployment Flow

```text
Deploy MyToken.sol
        |
        v
Calls ERC20 Constructor
        |
        v
Initialize:
- name
- symbol
- decimals
- initial supply
        |
        v
_mint(msg.sender, initialSupply)
        |
        v
Update:
- totalSupply
- deployer balance
        |
        v
Emit Transfer(address(0), deployer, amount)
        |
        v
Token Successfully Created
```

---

## transfer() Flowchart

```text
User Calls transfer(to, amount)
                |
                v
       Check Sender Balance
       (balance >= amount?)
                |
        +-------+-------+
        |               |
       NO              YES
        |               |
        v               v
   Transaction     Subtract Amount
     Reverts        From Sender
                        |
                        v
                    Add Amount
                    To Receiver
                        |
                        v
                   Emit Transfer Event
                        |
                        v
                   Return true
```

---

## approve() Flowchart

```text
User Calls approve(spender, amount)
                |
                v
            Store Allowance
    allowance[owner][spender] = amount
                |
                v
         Emit Approval Event
                |
                v
           Return true
```

---

## transferFrom() Flowchart

```text
Spender Calls transferFrom(from, to, amount)
                    |
                    v
               Check Balance
          (balanceOf[from] >= amount?)
                    |
            +-------+-------+
            |               |
           NO              YES
            |               |
            v               v
         Revert        Check Allowance
                      allowance[from][spender]
                           >= amount?
                               |
                     +---------+---------+
                     |                   |
                    NO                  YES
                     |                   |
                     v                   v
                   Revert          Reduce Allowance
                                         |
                                         v
                                   Subtract Tokens
                                     From Sender
                                         |
                                         v
                                     Add Tokens
                                     To Receiver
                                         |
                                         v
                                   Emit Transfer Event
                                         |
                                         v
                                   Return true
```

---

## Minting Operation Diagram

```text
   Before Mint

Total Supply = 1000
Alice Balance = 100

        |
        | _mint(Alice, 500)
        v
   After Mint

Total Supply = 1500
Alice Balance = 600
```

---

## Burning Operation Diagram

```text
   Before Burn
Total Supply = 1500
Alice Balance = 600

        |
        | _burn(Alice, 200)
        v
   After Burn
Total Supply = 1300
Alice Balance = 400
```

---

## approve() + transferFrom() Real DeFi Flow

```text
+--------+
| Alice  |
+---+----+
    |
    | approve(Uniswap, 500)
    v
+-------------------+
| ERC20 Contract    |
| allowance[Alice]  |
| [Uniswap] = 500   |
+---------+---------+
          |
          | transferFrom(Alice, Pool, 200)
          v
+-------------------+
| Uniswap Contract  |
+---------+---------+
          |
          v
+-------------------+
| Tokens Move       |
| Alice -> Pool     |
+-------------------+
```

---

## State vs Events Diagram

```text
+---------------------+
|   SMART CONTRACT    |
+----------+----------+
           |
           |
   +-------+-------+
   |               |
   v               v
+---------+   +----------------+
| STATE   |   | EVENT LOGS     |
+---------+   +----------------+
| balances|   | Transfer Event |
| supply  |   | Approval Event |
|allowance|   +----------------+
+---------+

STATE:
Actual blockchain data

EVENTS:
Historical notifications for wallets and dApps
```

---

## Direct Transfer vs Delegated Transfer

```text
DIRECT TRANSFER

Alice
  |
  | transfer(Bob, 100)
  v
Bob

-----------------------------------

DELEGATED TRANSFER

Alice
  |
  | approve(Uniswap, 500)
  v
Uniswap
  |
  | transferFrom(Alice, Pool, 200)
  v
Liquidity Pool
```

---

## ERC-20 Complete Mental Model

```text
ERC-20 Token
│
├── Ownership
│   └── balanceOf()
│
├── Direct Movement
│   └── transfer()
│
├── Permission System
│   ├── approve()
│   └── allowance()
│
├── Delegated Movement
│   └── transferFrom()
│
├── Supply Control
│   ├── _mint()
│   └── _burn()
│
└── Blockchain Notifications
    ├── Transfer Event
    └── Approval Event
```

---
