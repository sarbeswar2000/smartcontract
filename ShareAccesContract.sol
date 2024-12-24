// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
// this will the demo contract to be practice;
  contract ShareAccesContract{
 // here it is an contract that you can login as an admin and 
 // only admin can share access to the resources to other users 
 // if it a user or admin , he can see that.
   struct User{
      address user;
      uint256 balance;
      bool access;
   }
  address [] Admin; 
  address [] users;
  mapping (address => User[]) AccessList;
   function login_as_Admin() public { 
      Admin.push(msg.sender);
   }
    modifier  onlyAdmin (){
       require(isAdmin(msg.sender),"OnlyOwner can do it");
       _;
    }

    function isAdmin (address _admin) public view returns (bool){
         
          for(uint i=0; i<Admin.length;i++)
          {
             if(_admin==Admin[i])
             {
              return true;
             }
          }
          return false;
    }
    function  login_as(address _user)public{
      users.push(_user);
    }


   function shareAccess ( address _user) public   onlyAdmin  returns (string memory){
    
     if(isAvailabe_user(_user)){
      return "you have already a user ";
     }    
     AccessList[msg.sender].push(User(_user,10,true));
     return "Shared Access Succefully";  
   } 

   
   function isAvailabe_user( address _user) public  view returns (bool)
   {
      for(uint i=0;i<users.length;i++)
      {
          if(users[i]==_user)return true; 
      }
      return false;
   }
  }