// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyNFTMarket} from "../src/MyNFTMarket.sol";
import {SpaceNFT} from "../src/SpaceNFT.sol";
import {SpaceToken} from "../src/SpaceToken.sol";

contract MyNFTMarketTest is Test {
    MyNFTMarket public market;
    SpaceNFT public nft;
    SpaceToken public token;

    address tom = makeAddr("tom");

    function setUp() public {
        vm.startPrank(tom);

        market = new MyNFTMarket();
        nft = new SpaceNFT();
        token = new SpaceToken();

        vm.stopPrank();
    }

    function test_list() public {
        vm.startPrank(tom);

        nft.mint(tom, "www.baidu.com");
        nft.setApprovalForAll(address(market), true);

        market.list(address(nft), 1, 100);

        vm.stopPrank();

        assertEq(nft.ownerOf(1), address(market),"fail list");
    }

    function test_buy(uint256 x) public {
        test_list();

        address bob = makeAddr("bob");

        vm.startPrank(tom);

        token.transfer(bob, 1000000000);

        market.updateSPACE(address(token));

        vm.startPrank(bob);

        token.approve(address(market), 1000000000);

        market.buyNFT(address(nft), 1);

        vm.stopPrank();

        assertEq(nft.ownerOf(1), bob,"fail buy");
    }
}
