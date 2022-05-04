//SPDX-License-Identifier:UNLICENSED
pragma solidity>0.8.0;

import “@openzeppelin/contracts/token/ERC721/ERC721.sol”;
import “@openzeppelin/contracts/token/ERC721/security/ReentrancyGuard.sol”;
import “@openzeppelin/contracts/utils/Counters.sol”;


contract NFT is ReentrancyGuard {
     using Counters for Counters.Counter;
     Counters.Counter private itemIds;
     Counters.Counter private itemSold;

     address payable marketOwner;
//  set listing price
     uint listingFee = 0.01 ether;
     constructor() {
       marketOwner = msg.sender;
     }
/// @dev generate the data for the token`s metadata
     struct MarketItem {
            uint itemId;
            address nftContractAddress;
            uint256 tokenId;
            address payable owner;
            address payable seller;
            uint price;
            bool onSale;
    }
    /// @notice emit event on market Item creation
    event ItemCreated (
           uint indexed itemId, 
           address indexed nftContractAddress, 
           uint256 indexed tokenId,
           address seller;
           address owner;
           uint256 price;
           bool onSale;
           );

       //  link the id to he struct
    mapping(uint256 => MarketItem) private idTomarketItems;
    
      function mintNFT(address _nftContract, uint256 _tokenId, uint256 _price) public payable nonReentrant {
        require(_price > 0, “Price must be at least 1wei”);
        itemIds.increment();
        uint256 itemId = itemIds.current();
       marketItems[itemId] = MarketItem(itemId, _nftContract, _tokenId,payable(msg.sender), _price, true);
      IERC721(_nftContract).safeTransferFrom(msg.sender, address(this), tokenId);

}

/* Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
      return listingFee;
    }



  

   function sellNFT (address _nftContract, uint _itemId, uint amount) public payable nonReentrant {
        uint price = marketItems[_itemId].price;
        uint tokenId = marketItems[_itemId].tokenId;
        require(msg.value == price, “Please, pay the required price”);
       marketItems[_itemId].owner.transfer(msg.value - listingFee);
       IERC721(_nftContract).safeTransferFrom(address(this), msg.sender, tokenId);
       marketItems[_itemId].owner = msg.sender;
       marketItems[_itemId].onSale = false;
      payable(owner).transfer(listingFee);
}

  function fetchNFTs() public view returns (MarketItem[] memory) {
       uint256 numberOfItems = itemIds.current();
       MarketItem[] memory items = new MarketItem[](0);
      for(uint i = 1; i <= numberOfItems; i++) {
                if(marketItems[i].onSale == true) {
                       items.push(marketItems[i]);
                }
      }
      return items;
}


function fetchAllMyNFTs() public view returns (MarketItem[] memory) {
       uint256 numberOfItems = itemIds.current();
       uint itemCount = 0; 
       uint currentIndex = 0;
       for(uint i = 1; i <= numberOfItems; i++) {
                if(marketItems[i].owner == msg.sender) {
                       itemCount += 1;
                }
      }

       MarketItem[] memory items = new MarketItem[](itemCount);
      for(uint i = 1; i <= numberOfItems; i++) {
                if(marketItems[i].owner == msg.sender) {
                       items[currentIndex] = marketItems[i]);
                       currentIndex += 1;
                }
      }
      return items;
}

 function reSale(address _nftContract, uint _itemId) public payable nonReentrant {
      MarketItem myItem = marketItems[_itemId];
      require(msg.sender == myItem.owner, “You don’t own this item”);
      IERC721(_nftContract).safeTransferFrom(msg.sender, address(this), myItem.tokenId);
      myItem.onSale = true;
}



}
