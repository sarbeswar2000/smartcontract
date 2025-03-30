// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
//  demo ReentrancyAttackGuard.sol
// contract ReentrancyAttack{
     
//        address payable owner ; 
       
//        bool private lock ; 
//        uint  balance ;

//        constructor (uint _balance){
//            owner=payable(msg.sender);
//            balance=_balance;
//        }
//        modifier onlyOwner (){
//          require(msg.sender==owner);
//          _;
//        }
//        modifier nonReentrant {
//            require(!lock,"");
//            lock=true;
//            _;
//            lock=false;
//        }
//        function Withdraw (address _to,uint256 _amount) external nonReentrant{
//                require(balance>0,'insufficient balance please add some funds');
//               (bool success,)= _to.call{value:_amount}("");
//               require(success,"Trasanction Failed !");
//                balance-=_amount;
//        }
// }

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ReentrancyAttackGuard is ReentrancyGuard {
     
     mapping(address=>uint256) public balances;
    
      function deposit()public payable{
          
           balances[msg.sender]+=msg.value;
      }
      
      function withdraw (uint256 _amount) external  nonReentrant {

            
            require(balances[msg.sender]>=_amount,"Insuffiecient balance"); 
            balances[msg.sender]=balances[msg.sender]-_amount;

            (bool success,)=payable(msg.sender).call{value:_amount}("");
            require(success,"Trasanction Failed");
      }


}