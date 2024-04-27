// SPDX-License-Identifier: UNLICENSED
pragma solidity  0.8.20;
import "forge-std/Test.sol";
import { NFTMarket } from "../src/Market.sol";
import { ERC721Mock } from './mock/ERC721mocklist.sol';
 import { BaseERC20 } from '../src/BaseERC20.sol';

 import { TokenBank } from '../src/TokenBank.sol' ;
error ERC721InsufficientApproval(address spender,address tokenId) ;
contract NFTMarketTest is Test {
    
    NFTMarket  mkt;

    ERC721Mock nft; // mint

    address alice = makeAddr('alice'); // 地址打印方便

    BaseERC20 ercToken ;

    TokenBank  TBK;
    //  error ERC721InsufficientApproval(address spender,address tokenId) ;
 // 初始化要有nft
    function setUp() public {

        //   vm.startPrank(alice) ;

          nft = new ERC721Mock('sl','sl');

          ercToken = new BaseERC20(); // 代币

          mkt = new NFTMarket(address(ercToken) , address(nft) );

          TBK = new TokenBank();

    } 
    // 1.没有授权转账失败的案例
    function test_list() public {

      nft.mint(alice,1);

      vm.startPrank(alice);

    //  vm.expectRevert(ERC721InsufficientApproval.selector);
    //   console.log('--------->',ERC721InsufficientApproval.selector);
      nft.setApprovalForAll(address(mkt),true); // alice去给合约授权
      
      mkt.list(1,10);                           // alice去操作上架

      assertEq( mkt.tokenSeller(1) , alice,'alice----------tokenSeller');
      assertEq( mkt.tokenIdPrice(1) , 10,'alice----------tokenIdPrice');


    } 
    function test_buy() public {

     test_list();
 
     address bom = makeAddr('bom');
     
     ercToken.mint(bom,100000); // 给bom给了token

     vm.startPrank(bom);       

     ercToken.approve(address(mkt),10000);  // bom给合约授权1000额度的token

    // uint256 preBalance = ercToken.balanceOf(bom);


     mkt.buy(1,12);                          // bom去买了id为1的nft 付钱12
     
     assertEq(nft.ownerOf(1) ,bom ,'bom--------------->');

    //  ercToken.balanceOf(alice);
    
    } 

    function test_deposit() public{
        
        address testTK = makeAddr('testTK');

        ercToken.mint(address(testTK),1000); // 给bom给了token

        uint256 balances =  ercToken.balanceOf(testTK);
         
        vm.startPrank(testTK);  

        ercToken.approve(address(TBK),1000);

        TBK.deposit(address(ercToken), 100);
        
        assertEq(ercToken.balanceOf(testTK) , balances - 100,'testTK--------------->');
      
    }


    function test_withdraw() public{

        address testTK = makeAddr('testTK');

        ercToken.mint(address(testTK),1000); // 给bom给了token
         
        vm.startPrank(testTK);  

        ercToken.approve(address(TBK),1000);

        TBK.deposit(address(ercToken), 100);

        uint256 bal =  ercToken.balanceOf(testTK);

        uint256 amount = 10;
        
        TBK.withdraw(address(ercToken),amount);
   
        assertEq(ercToken.balanceOf(testTK) , bal + amount ,'testTK--------------->');
    
    }

}

