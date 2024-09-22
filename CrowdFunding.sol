// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;


contract CrowdFunding{
    enum StateOfContract { Fundraising, Expired, Success, Closed }
    address public admin;
    address payable public beneficiary;
    uint public goal;
    StateOfContract public State = StateOfContract.Fundraising;
    uint public TotalRaised;
    uint public Raiseby;
    uint public Currentbalance;
    uint public CompleteAt;
    constructor (uint TimeInHoursForFundraising ,address payable FundReceipient,uint _minimumtoraised){
         admin=msg.sender;
         beneficiary=FundReceipient;
         goal=_minimumtoraised*10**8;
         Raiseby=block.timestamp+(TimeInHoursForFundraising);
         Currentbalance=0;
    }
    modifier ifState(StateOfContract  _stateofcontract)
    {
          require(State ==_stateofcontract);
          _;
    }
    struct Donation{
        uint amount;
        address donor;
    }
    Donation[]public donations;
    function donate ()public  payable  ifState(StateOfContract.Fundraising) returns(uint){ 
        
          donations.push(Donation(msg.value,msg.sender));
           TotalRaised+=msg.value;
           Currentbalance=TotalRaised;
           return msg.value;
    }
    function isFundRaisingCompleteOrExpired() private{
         if(TotalRaised>=goal)
         {
             State=StateOfContract.Success;
             payBeneficiary();
         }
         else if(block.timestamp> Raiseby)
        {
              State=StateOfContract.Expired;
        }
        CompleteAt=block.timestamp;
    }
    function payBeneficiary ( )  ifState(StateOfContract.Success) public  payable returns(uint){
        require(msg.sender==admin|| msg.sender==beneficiary,"only admin and beneficiary can call this");
           beneficiary.transfer(address(this).balance);
           State=StateOfContract.Closed;
           Currentbalance=0;
           return beneficiary.balance;
    }
    function withdrawDonation (uint256 id) public  returns (bool){
          if(id >=donations.length)
          {
              revert("HERE you Have not Donate Anything");
          }
          else if(donations[id].amount==0){
             revert(" Here you have not Sufficient Money to donate");
            
          }
          payable (donations[id].donor).transfer(donations[id].amount);
          TotalRaised-=donations[id].amount;
          donations[id].amount=0;
          Currentbalance=TotalRaised;
          return true;
    }
    
}