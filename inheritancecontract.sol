// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

 contract ERC20Token {
     mapping (address=>uint256)balances;
      string myname;
    constructor(string memory _myname){
         myname=_myname;
    }
     function mint() virtual  public 
     {
         balances[tx.origin]++;
     }
 }
 contract inherittoken is ERC20Token{
    string symbol;
    address [] public owner;
    uint public ownercount;
    constructor (string memory _symbol,string memory _myname)
    ERC20Token(_myname)
    {
       symbol=_symbol;   
    }
    function  mint() override public {
      super.mint();
      ownercount++;
      owner.push(msg.sender);
    } 
 }