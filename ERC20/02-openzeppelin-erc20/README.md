# ERC-20 With OpenZeppelin

**Project 02 of the Solidity Portfolio**  
Built using OpenZeppelin 5.0.0 · Solidity 0.8.30

If you haven't seen [Project 01](../01-erc20-from-scratch/) yet, start there.  
This project will make a lot more sense once you've seen what OpenZeppelin is replacing.

---

## What This Project Is About

Project 01 proved I could write ERC-20 from scratch.  
This project answers the next question: how do you build it properly for production?

The answer is OpenZeppelin — an audited, battle-tested library used across
billions of dollars in deployed contracts. The goal here is not just to import it,
but to understand every piece it provides and exactly how to wire it together.

---

## What This Token Can Do

The base ERC-20 standard only covers transfers, balances, and allowances.  
This contract adds three things on top of that:

**Minting** — new tokens can be created after deployment, but only by addresses
holding `MINTER_ROLE`. Everyone else gets rejected at the function level.

**Burning** — any holder can destroy their own tokens via `burn()`.
A contract with sufficient allowance can burn on behalf of a user via `burnFrom()`.
Both functions come from `ERC20Burnable` — no extra code needed.

**Pausing** — all transfers can be frozen instantly with `pause()`.
This is an emergency mechanism. One call stops everything.
One call brings it back. Only `PAUSER_ROLE` holders can do either.

---

## How Access Control Works

Instead of a single owner, this contract uses separated roles:

```
DEFAULT_ADMIN_ROLE   →   grants and revokes all other roles
MINTER_ROLE         →   can call mint()
PAUSER_ROLE         →   can call pause() and unpause()
```

At deployment the deployer receives all three.  
From there, each role can be delegated independently to different addresses —
a multisig, a separate contract, a security team. No single point of failure.

---

## The One Thing I Had to Write Manually

Almost everything here is inherited. But when two parent contracts define
the same internal function, Solidity forces you to resolve the conflict explicitly.

Both `ERC20` and `ERC20Pausable` define `_update()` internally.
Without this override the contract does not compile:

```solidity
function _update(address from, address to, uint256 value)
    internal
    override(ERC20, ERC20Pausable)
{
    super._update(from, to, value);
}
```

`super._update()` runs the inheritance chain in order —  
`ERC20Pausable` checks the pause state first, then `ERC20` updates the balances.

Three lines. But knowing *why* they exist is the whole point of project 01.

---

## What OpenZeppelin Replaced

| Project 01 — written manually | Project 02 — inherited from OZ |
|-------------------------------|--------------------------------|
| Balance mapping + getter | `ERC20` |
| Transfer logic + checks | `ERC20` |
| Allowance system | `ERC20` |
| Events | `ERC20` |
| `_mint` and `_burn` internals | `ERC20` |
| Pause state + enforcement | `ERC20Pausable` |
| Role management | `AccessControl` |

What I actually wrote: role constants, constructor, `mint()`, `pause()`,
`unpause()`, and the `_update()` override. That's it.

---
