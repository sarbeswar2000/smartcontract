// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

 contract Txorigin{

     address payable owner ;
    constructor(){
         owner = payable(msg.sender);
    }
   receive () payable external{} 
    function withdraw_funds ()payable external{

         require(tx.origin==owner);
         // transfering funds to the owners account; 
         
         owner.transfer(address(this).balance);

    }

 }

 contract Attack {
       Txorigin txorigin ;
      address payable Attackowner ; 
       constructor (Txorigin _txorigin){
              txorigin=Txorigin(_txorigin);
              Attackowner= payable(msg.sender);
       }
       modifier onlyAttackowner (){
         require(Attackowner==msg.sender);
         _;
       }

       function exploit () public  onlyAttackowner{
           txorigin.withdraw_funds();
       }
 }