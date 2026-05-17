// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "../interfaces/IERC20.sol";

contract ERC20 is IERC20 {
    string public name; //full token name
    string public symbol; //short name ex(ETH, USDT)
    uint8 public decimals; //smallest unit
    uint256 public totalSupply; //Total number of tokens in existence
    
    mapping(address => uint256) public balanceOf; // this is like your bank database
    mapping(address =>mapping(address => uint256)) public allownce; //Owner → Spender → Amount allowed ex(Alice → Uniswap → 500 tokens)

    //event Transfer(address indexed from,address indexed to, uint256 value); //Logs every token movement
    //event Approval(address indexed owner, address indexed spender, uint256 value); // Logs permission changes

    constructor( //when Deploy contract → create money → assign to creator
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ){
        name =_name;
        symbol = _symbol;
        decimals=_decimals;
        
        _mint(msg.sender,_initialSupply);
    }

    function _mint(address to, uint256 amount) internal {
        /*
        Creates new tokens:
            increases total supply
            assigns tokens to user
            logs creation event
        */
        require( to != address(0), "mint to zero address");
        totalSupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool){
        /*
        Step by step of (Moving numbers between accounts):
            check sender has enough tokens
            remove tokens from sender
            add tokens to receiver
            log event
        */
        require(to != address(0),"invalid address");
        require(balanceOf[msg.sender] >= amount,"insuffecient amount");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender,to,amount);
        return true;

    }

    function approve(address spender,uint256 amount) public override returns (bool){

        //"I allow this contract to use my tokens"

        require(spender != address(0),"invalid spender");

        allownce[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;

    }

    function transferFrom(address from, address to, uint256 amount) public override returns(bool){
        /*
        Function flow:
            check balance
            check permission
            reduce allowance
            move tokens
            emit event
        */
        require(balanceOf[from] >= amount,"insufficient balance");
        require(allownce[from][msg.sender] >= amount,"allowance exceeded");
        allownce[from][msg.sender] -= amount;

        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from,to,amount);
        return true;
    }



}