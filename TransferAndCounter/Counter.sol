// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Counter {
    uint256 counter;

    function add(uint256 x) public {
        counter = counter + x;
    }

    function get() public view returns (uint256) {
        return counter;
    }
}
