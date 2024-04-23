//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SpaceToken is ERC20 {
    constructor() ERC20("Space Token", "SPACE") {
        _mint(address(msg.sender), 1000000000000000000000 * 10**18);
    }

    function transfer(address to, uint256 amount) public override  returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");

        super.transfer(to, amount);

        if (isContract(to)) {
            bytes memory methodData = abi.encodeWithSignature(
                "tokensReceived(address,uint256)",
                msg.sender,
                amount
            );
            (bool success, ) = to.call(methodData);
            require(success, "token received failed");
        }

        return true;
    }

    function transferForBuyNFT(address to, uint256 amount, address nftAddress, uint256 tokenId) public returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");

        super.transfer(to, amount);

        if (isContract(to)) {
            bytes memory methodData = abi.encodeWithSignature(
                "tokensReceived(address,uint256,address,uint256)",
                msg.sender,
                amount,
                nftAddress,
                tokenId
            );
            (bool success, ) = to.call(methodData);
            require(success, "token received failed");
        }

        return true;
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
}
