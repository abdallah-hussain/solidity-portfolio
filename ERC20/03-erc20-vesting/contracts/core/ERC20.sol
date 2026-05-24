// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "../interfaces/IERC20.sol";

contract ERC20 is IERC20 {
    string public name; //full token name
    string public symbol; //short name ex(ETH, USDT)
    uint8 public decimals; //smallest unit
    uint256 private _totalSupply; //Total number of tokens in existence
    
    //--------- Private State -----------------
    // State is private so only this contract can modify it directly.
    // External access goes through the functions below.

    mapping(address => uint256) private _balances; // this is like your bank database
    mapping(address =>mapping(address => uint256)) private _allowances; //Owner → Spender → Amount allowed ex(Alice → Uniswap → 500 tokens)

    //event Transfer(address indexed from,address indexed to, uint256 value); //Logs every token movement
    //event Approval(address indexed owner, address indexed spender, uint256 value); // Logs permission changes

    constructor( //when Deploy contract → create money → assign to creator
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ){
        name = _name;
        symbol = _symbol;
        decimals=_decimals;
        
        if (_initialSupply > 0) {//Convert whole token amount to raw units before minting.
            _mint(msg.sender, _initialSupply * (10 ** uint256(_decimals)));
        }
    }

    // ----------------------ERC-20 Read Functions -------------

    // Returns the total token supply 
    function totalSupply() external  view returns (uint256){
        return _totalSupply;
    }
    // Returns the raw token balance of any address
    function balanceOf(address account) external view returns (uint256){
        return _balances[account];
    }

    // Returns how many tokens spender is allowed to use from owner

    function allowance(address owner, address spender) external view returns (uint256){
        return _allowances[owner][spender];
    }


    // ----------------------ERC-20 Write Functions -------------

    function transfer(address to, uint256 amount) public override returns (bool){
        /*
        Step by step of (Moving numbers between accounts):
        call _transfer() function that do the following:
            check sender has enough tokens
            remove tokens from sender
            add tokens to receiver
            log event
        */
        _transfer(msg.sender,to,amount);
        
        return true;

    }

    function approve(address spender,uint256 amount) public override returns (bool){

        //"I allow this contract to use my tokens"

        require(spender != address(0),"invalid spender");

        _allowances[msg.sender][spender] = amount;

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
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(_allowances[from][msg.sender] >= amount,"allowance exceeded");
        _allowances[from][msg.sender] =  currentAllowance - amount;
        _transfer(from,to,amount);
        return true;
    }

    // ─-----------─ Internal Core Functions -------------------

    // _transfer() it's share logic used by both transfer() and transferFrom() 
    // Checks:
    // - neither address is the zero address
    // - sender has enough balance
    //
    // Effects:
    // - deducts from sender
    // - credits receiver
    // - emits Transfer event

    function _transfer(address from, address to, uint256 amount) internal{
        require(from != address(0),"ERC20: transfer from zero address");
        require(to != address(0), "ERC20: transfer to zero address");
        require(_balances[from] >= amount,"ERC20: insufficient balance");

        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from,to,amount);
    }

    function _mint(address to, uint256 amount) internal {
        /*
        Creates new tokens:
            increases total supply
            assigns tokens to user
            logs creation event
        */
        require( to != address(0),  "ERC20: mint to zero address");
        _totalSupply += amount;
        
        _balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }



}