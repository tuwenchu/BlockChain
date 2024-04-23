// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyNFTMarket {
    event List(
        address indexed user,
        address indexed nftAddress,
        uint256 tokenId,
        uint256 price
    );
    event Cancel(
        address indexed user,
        address indexed nftAddress,
        uint256 tokenId
    );
    event BuyNFT(
        address indexed user,
        address indexed preOwner,
        address indexed nftAddress,
        uint256 tokenId,
        uint256 price
    );

    struct SaleNFT {
        address seller;
        uint256 price;
        uint256 onSaleTime;
        bool onSale;
    }

    mapping(address => mapping(uint256 => SaleNFT)) public saleNfts;

    ERC20 SPACE;

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;

        SPACE = ERC20(0x0F4119dE390BC916d0331B97a916B6b327831391);
    }

    function updateSPACE(address token) external onlyOwner {
        SPACE = ERC20(token);
    }

    function rescueToken(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(msg.sender, amount);
    }

    function list(
        address nftAddress,
        uint256 tokenId,
        uint256 price
    ) external {
        require(msg.sender == ERC721(nftAddress).ownerOf(tokenId), "not owner");
        require(price > 0, "price error");

        saleNfts[nftAddress][tokenId] = SaleNFT(
            msg.sender,
            price,
            _getTs(),
            true
        );

        ERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId);

        emit List(msg.sender, nftAddress, tokenId, price);
    }

    function cancel(address nftAddress, uint256 tokenId) external {
        require(msg.sender == saleNfts[nftAddress][tokenId].seller, "not owner");

        saleNfts[nftAddress][tokenId].onSale = false;

        ERC721(nftAddress).transferFrom(address(this), msg.sender, tokenId);

        emit Cancel(msg.sender, nftAddress, tokenId);
    }

    function buyNFT(address nftAddress, uint256 tokenId) external {
        require(saleNfts[nftAddress][tokenId].onSale, "selled");
        uint256 price = saleNfts[nftAddress][tokenId].price;
        uint256 tokenBalance = SPACE.balanceOf(msg.sender);
        require(tokenBalance >= price, "balance error");

        saleNfts[nftAddress][tokenId].onSale = false;

        address seller = saleNfts[nftAddress][tokenId].seller;

        require(SPACE.transferFrom(msg.sender, seller, price), "transfer error");

        ERC721(nftAddress).transferFrom(address(this), msg.sender, tokenId);

        emit BuyNFT(
            msg.sender,
            seller,
            nftAddress,
            tokenId,
            price
        );
    }

    function tokensReceived(
        address buyer,
        uint256 amount,
        address nftAddress,
        uint256 tokenId
    ) public {
        require(msg.sender == address(SPACE), "must called by token");
        require(saleNfts[nftAddress][tokenId].onSale, "selled");
        uint256 price = saleNfts[nftAddress][tokenId].price;
        require(amount >= price, "amount not enough");

        address seller = saleNfts[nftAddress][tokenId].seller;

        require(SPACE.transfer(seller, price), "transfer error");

        saleNfts[nftAddress][tokenId].onSale = false;

        ERC721(nftAddress).transferFrom(address(this), buyer, tokenId);

        emit BuyNFT(
            buyer,
            seller,
            nftAddress,
            tokenId,
            price
        );
    }

    function _getTs() internal view returns (uint64) {
        return uint64(block.timestamp);
    }
}
