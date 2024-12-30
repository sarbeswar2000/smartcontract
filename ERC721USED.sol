pragma solidity 0.8.26;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract ERC721USED is ERC721URIStorage {
    
     using Counters for Counters.Counter;
      Counters.Counter private _tokenIds ;
     constructor  ()ERC721 ("ERC721USED","ercu"){

     }
     function mint(string memory TokenUri) returns (uint256){
         _tokenIds.increment();
         uint256 newitemId=_tokenIds.current();
         _mint(msg.sender,newitemId);
         _setTokenURI(newitemId,TokenUri);

        return newitemId;
     }
}