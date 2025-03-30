// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract PullpaymentDepositContract is PullPayment , Ownable{

    function SendEther (address payable payee) external payable onlyOwner {
         
         require(msg.value>0,"You must send some Ether");
         _asyncTransfer(payee,msg.value);
    } 

}
contract PullpaymentWithdrawalContract is PullPayment{

      function WithdrawalEther () public  {
           withdrawPayments(payable(msg.sender));
      }
}