// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "../core/ERC20.sol";

contract MyToken is ERC20 {
    constructor()
        ERC20( // this calls the parent ERC20 constructor
            "My Token",
            "MTK",
            18,
            1000000 // 1 million FULL tokens where this conversation( 1000000 * 10**18 ) is done inside core ERC20.so;
        )
    {}

}