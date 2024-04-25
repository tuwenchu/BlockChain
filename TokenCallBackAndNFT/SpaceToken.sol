//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ICallBackContract {
    function tokensReceived(address from, uint256 amount, bytes memory data) external returns (bool);
}

contract SpaceToken is ERC20 {
    constructor() ERC20("Space Token", "SPACE") {
        _mint(address(msg.sender), 1000000000000000000000 * 10**18);
    }

    function transferCallBack(address to, uint256 amount, bytes memory data) public returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");

        super.transfer(to, amount);

        if (isContract(to)) {
            bool success = ICallBackContract(to).tokensReceived(msg.sender, amount, data);
            require(success, "Call back failed");
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
