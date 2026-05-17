// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

interface IERC20 {
    // -------------------------
    // Read functions
    // -------------------------
    function totalSupply() external view returns (uint256); // read-only function to view How many tokens exist in total
    function balanceOf(address account) external view returns (uint256);// read-only function to view How many tokens does this wallet own
    function allownce(address owner , address spender) external view returns (uint256);// read-only function to view How many tokens is spender allowed to use from owner
    
    // -------------------------
    // Write functions
    // -------------------------
    function transfer (address to, uint256 amount) external returns (bool); // return --> Did the operation succeed or fail?
    function approve (address spender,uint256 amount) external returns (bool); // return --> Give permission to someone to use your tokens or not?
    function transferFrom (address from,address to,uint256 amount) external returns (bool); //Spend tokens on behalf of someone else (with permission)

    // -------------------------
    // Events
    // -------------------------
    event Transfer(address indexed from,address indexed to, uint256 value); //Logs every token movement
    event Approval(address indexed owner, address indexed spender, uint256 value); // Logs permission changes

}