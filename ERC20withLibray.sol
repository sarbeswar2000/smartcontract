 
 pragma solidity 0.8.26;
 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";//
  
 //    interface IERC20  {
//       function totalSupply () public  returns(uint);
//       function balanceOf(address TokenOwner)public returns(uint balance);
//       function allowance(address TokenOwner,address spender)public returns(uint remaining);
//       function transfer(address to,uint amount) public returns(bool success);
//       function approve(address spender,uint tokens) public returns(bool success);
//       function transerFrom(address from, address to , uint tokens)public returns(bool success);
      
//       event Transfer( address indexed from, address indexed to , uint tokens);
//       event approval (address owner, address spender, uint tokens);

//  }
 

 contract AmazonKoin is ERC20 {
        address private owner;
        
        uint public _totalSupply;
        mapping (address=>uint)balances;
       mapping(address=>mapping(address=>uint))allowed;
       constructor () ERC20 ("AmazonKoin","AMK"){
           owner=msg.sender;
           _totalSupply=1000000;
       }
       function mint()public {
            _mint(owner,_totalSupply*10**decimals());
       }


       function totalSupplyTokens() public view returns(uint){
              return totalSupply();
       }
       function Balanceof_Account(address off)public view returns (uint){
         return balanceOf(off);
       }
       function TransferOwner_To_Spender(address to,uint amount) public  returns(bool){
              transfer(to,amount);
              return true;
       }
       function TranserUser_to_User(address from, address to , uint amount)public returns (bool)
       {
            transferFrom(from, to, amount);
            return true;
       }
       function CheckAllowance(address _owner, address spender) external view  returns(uint){
           return allowance(_owner,spender);
           
       }
 }