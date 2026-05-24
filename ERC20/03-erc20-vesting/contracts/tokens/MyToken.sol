// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "../core/ERC20.sol";


//Simple ERC20 token used by the vesting system.
/*
    1- Deploy MyToken
    2- constructor(initialSupply)
    3- call ERC20 constructor
    4- set metadata
    5- mint supply
    6- contract deployed
*/
contract MyToken is ERC20 {

    constructor( //Call parent constructor
        uint256 initialSupply
    )
        ERC20(
            "My Token",
            "MTK",
            18,
            initialSupply
        )
    {}
}