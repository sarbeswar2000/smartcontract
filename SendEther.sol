
  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// send ether using 
contract SendEther {
    // Address to which Ether will be sent
    mapping (address=>uint)public Senders;
    mapping (address=>bool)isSenders;
     string public fallbackmessage;
       event ReceivedEther(address sender, uint amount, bytes data);
    // Constructor that accepts an address and transfers Ether to it
     constructor (){

     }
      receive() external payable { }

     function sendEtherTOOwner() public  payable  returns (bool) {
        require(msg.value >0,"you must have some ether to send ");
        addSender( msg.sender,msg.value);  
        bool result =payable(address(this)).send(msg.value);
        return result ;
     }
     

    // Fallback function to handle calls with data
    fallback() external payable {
        // emit ReceivedEther(msg.sender, msg.value, msg.data);
        fallbackmessage=string(msg.data);
    }
    
     function sendEtherToOwnerBytransfer() public  payable {
         require(msg.value>0,"you must have some ether to send");
         addSender(msg.sender,msg.value);
         payable(address(this)).transfer(msg.value); 
         // ensure that u must have written fallback function.
     }

     function sendEtherToOwnerByCall()public payable {
        require(msg.value>0,"you must have some ether to send");
         addSender(msg.sender,msg.value);
         (bool success,)=payable(address(this)).call{value:msg.value}("hi i am sarbeswar");
         require(success,"Trasanction Failed");
     }
    function addSender(address payer, uint _amount) private    {
          if(isSenders[payer]){
            Senders[payer]+=_amount;
          }
          else {
            Senders[payer]=_amount;
            isSenders[payer]=true;
          }
     }
     
    
    // Function to check the balance of the contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
