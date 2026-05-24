# Token Vesting — Implementation Notes

## Why Linear Vesting?

Linear vesting is one of the most common token distribution models in blockchain systems.

After the cliff expires, tokens unlock continuously over time based on elapsed duration.

### Benefits

- simple to understand
- predictable token release
- transparent accounting
- easy to audit and verify

---

# Why One Vesting Per Address?

This implementation intentionally supports one vesting schedule per beneficiary.

The goal is to keep the architecture:

- simple
- readable
- educational

Production systems commonly support multiple vesting schedules per address.

---

# Why Update State Before Transfers?

The contract follows the checks-effects-interactions pattern.

## Secure Order

```text
1. Validate conditions
2. Update storage
3. Transfer tokens
```

## Unsafe Order

```text
1. Transfer tokens
2. Update storage
```

If tokens are transferred before state updates complete, an attacker could attempt recursive withdrawals before balances are updated.

Updating storage first prevents this attack vector.

---

# Why Use block.timestamp?

Vesting schedules are based on real-world time.

`block.timestamp` maps naturally to:

- seconds
- days
- months
- years

Block numbers are unsuitable because block production intervals vary across networks.

---

# Why Fair Cancellation Matters

If part of a vesting schedule has already vested, those tokens belong to the beneficiary.

The contract guarantees:

- vested tokens → beneficiary
- unvested tokens → owner

Cancellation cannot revoke already vested allocations.

---

# Security Decisions

## Reentrancy Protection

Sensitive functions use:

- `nonReentrant`
- checks-effects-interactions

This prevents recursive withdrawal attacks.

---

## Custom Errors

The contract uses Solidity custom errors instead of revert strings.

### Benefits

- lower gas consumption
- cleaner debugging
- improved tooling support

### Example

```solidity
error InvalidBeneficiary();
error NothingToClaim();
error Unauthorized();
```

---

# Production Improvements

A production-grade vesting system would typically include:

| Feature | Purpose |
|---|---|
| Multiple vestings per address | Greater flexibility |
| Multisig ownership | Reduces single-point failure |
| Timelocked admin actions | Improves transparency |
| Full automated test suite | Covers edge cases |
| Upgradeability support | Allows future improvements |
| Event indexing strategy | Better frontend integration |

---

