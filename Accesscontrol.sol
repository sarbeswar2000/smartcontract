// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/access/AccessControl.sol';


contract AccessControls is AccessControl {
     
     bytes32  public HashAdminRole=keccak256("adminrole");

     function GrantRole(bytes32 role)  public{
         _grantRole(role,msg.sender);
     }
    function CheckGrantRole() public  view returns (string memory){
         if(hasRole(HashAdminRole,msg.sender)){
             return "You have Access";
         }
         else{
             return "No access";
         }
    }
}