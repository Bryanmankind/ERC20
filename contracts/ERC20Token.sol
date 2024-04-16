// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract MyERC20Token{
    /** This protects the contract from integer overflow and underflow*/
    using SafeMath for uint256;

    // Set initial values for contract.
    string public constant Name = 'BriTech';
    string public constant Symbol = 'BIT';
    uint public constant Decimal = 18;

    /** This event is emitted when tokens are transferred from one account to another. */ 
    event transfer(address indexed from, address indexed to, uint numTokens);

    /** This event is emitted when tokens are approved for transfer from one account to another. */ 
    event approves(address indexed owner, address indexed delegate, uint numToken);

    /** Balances*/
    mapping (address => uint) balance;

    /** Allowance*/
    mapping (address => mapping(address =>uint )) allowed;

    uint256 totalSupply;

    // Called once for inital values for the contract when the contract is deployed.

    constructor() {
        totalSupply = 10000;
        balance[msg.sender] = totalSupply;    
    }

    //REQUIRED ERC20 FUNCTIONS.
    /** Returns the total supply of tokens available*/

    function TotalSupply()public view returns (uint) {
        return totalSupply;
    }

    /** Returns available token in a given owner*/
    function BalanceOf (address owner) public view returns (uint) {
        return balance[owner];
    }

    /** Transfers tokens from a sender account to receiver account*/

    function Transfer (address receiver, uint NumToken) public returns (bool) {
        require (NumToken <= balance[msg.sender]);
        balance[msg.sender] = balance[msg.sender] .sub(NumToken);
        balance[receiver] = balance[receiver] .add(NumToken);
        emit transfer (msg.sender, receiver, NumToken);
        return true;
    }

    /** Approve spender to spend token from caller's account.*/
    function Approve (address sender, uint NumToken) public returns (bool) {
        allowed[msg.sender][sender] = NumToken;
        emit approves (msg.sender,sender, NumToken);
        return true;
    }

    /** Return the tokens that spender is still allowed to return from tokenOwner.*/
    function Allowance (address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    /** Transfer tokens from one account to another account*/
    function TransferFrom (address owner, address buyer, uint NumToken) public returns (bool) {
        require (NumToken <= balance[owner]);
        require (NumToken <= allowed[owner][msg.sender]);

        balance[owner] = balance[owner] .sub(NumToken);
        balance[buyer] = balance[buyer] .add(NumToken);
        emit transfer(owner, buyer, NumToken);
        return true;
    }

    /** Create new tokens */
    function Mint (address owner, uint NumToken) external returns (bool) {
        require (msg.sender == owner, 'You must be the owner');
        balance[owner] = balance[owner] .add(NumToken);
        totalSupply = totalSupply .add(NumToken);
        return true;
      
    }

    /** Burning off token*/
    function Burn (address owner, uint NumToken) external returns (bool) {
        require (msg.sender == owner, 'You must be the owner');
        balance[ owner] = balance[ owner] .sub(NumToken);
        totalSupply = totalSupply .sub(NumToken);
        return true;
    }
 
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert (b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint c = a + b;
        assert (c >= a);
        return c;
    }
}