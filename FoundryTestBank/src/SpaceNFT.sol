// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";

contract SpaceNFT is ERC721URIStorage {
    address public owner;

    // using Counters for Counters.Counter;

    // Counters.Counter public _tokenIds;

    uint256 counter;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() ERC721("Open Space NFT", "OPNFT") {
        owner = msg.sender;
    }

    function mint(address to, string memory tokenURI) public onlyOwner returns (uint256) {
        // _tokenIds.increment();
        // uint256 newItemId = _tokenIds.current();
        counter++;
        uint256 newItemId = counter;
        _mint(to, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}
