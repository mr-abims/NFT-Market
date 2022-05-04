// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address marketAddress;

    constructor(address _NftAddress) ERC721("Market NFT", "MNFT") {
        marketAddress = _NftAddress;
    }

    function createToken(string memory _tokenURI) public returns (uint iD) {
        _tokenURI = tokenURI;
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(marketAddress, true);
        return newItemId;
    }
}