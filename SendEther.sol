
  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendEther {
    // Address to which Ether will be sent
    address payable public recipient;

    // Constructor that accepts an address and transfers Ether to it
    constructor(address payable _recipient) payable {
        require(msg.value > 0, "Must send some Ether");
        recipient = _recipient;
        
        // Send Ether to the recipient
        recipient.transfer(msg.value);
    }

    // Function to check the balance of the contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
