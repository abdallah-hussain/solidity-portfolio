# Token Vesting — Diagrams & Flows

---

# 1. Vesting Timeline

```text
Tokens available:

100% │                                    ╭──────────
     │                               ╭───╯
 50% │                          ╭────╯
     │                     ╭────╯
  0% ├─────────────────────┴────────────────────────
     start             cliff ends          duration ends
     (locked)          (unlock begins)     (fully vested)
```

---

# 2. Vesting Creation Flow

```text
Owner calls createVesting()
│
├── Validate beneficiary address
├── Validate amount > 0
├── Validate duration > 0
├── Ensure no active vesting exists
│
├── Store vesting schedule
├── Transfer tokens into contract
└── Vesting successfully created
```

---

# 3. Claim Flow

```text
Beneficiary calls claim()
│
├── Calculate vested amount
├── Calculate releasable amount
├── Ensure claimable amount > 0
│
├── Update storage FIRST
├── Transfer tokens to beneficiary
└── Claim completed
```

---

# Why Update Storage First?

```text
Correct Order:
1. Update storage
2. Transfer tokens

Unsafe Order:
1. Transfer tokens
2. Update storage
```

Updating state before transfers prevents reentrancy attacks and double withdrawals.

This follows the Solidity checks-effects-interactions security pattern.

---

# 4. Vesting Cancellation Flow

```text
Owner calls cancelVesting()
│
├── Verify vesting exists
├── Calculate vested amount
├── Calculate refundable amount
│
├── Delete vesting record
├── Send vested tokens → beneficiary
├── Send unvested tokens → owner
└── Cancellation completed
```

---

# 5. Token Flow

## At Vesting Creation

```text
Owner Wallet
    │
    └── transferFrom()
            ↓
TokenVesting Contract
```

---

## At Claim

```text
TokenVesting Contract
            │
            └── transfer()
                    ↓
Beneficiary Wallet
```

---

## At Cancellation

```text
TokenVesting Contract
│
├── vested tokens   → Beneficiary
└── unvested tokens → Owner
```

---

# 6. Balance Example

1,000,000 MTK · 24-Month Duration · 6-Month Cliff

```text
START
Owner:    1,000,000 MTK
Contract:         0 MTK
Alice:            0 MTK

AFTER createVesting()
Owner:            0 MTK
Contract: 1,000,000 MTK
Alice:            0 MTK

AFTER claim at Month 12
Owner:            0 MTK
Contract:   500,000 MTK
Alice:      500,000 MTK

AFTER cancellation at Month 18
Alice receives: 250,000 MTK
Owner receives: 250,000 MTK

FINAL
Contract:         0 MTK
Alice:      750,000 MTK
Owner:      250,000 MTK
```