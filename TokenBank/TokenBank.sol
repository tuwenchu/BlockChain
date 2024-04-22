// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBaseERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract TokenBank {
    IBaseERC20 public base;

    mapping(address => uint256) public userDeposit;

    event Deposit(address indexed from, uint256 amount);

    event Withdraw(address indexed from, uint256 amount);

    constructor() {
        base = IBaseERC20(0xC3Ba5050Ec45990f76474163c5bA673c244aaECA);
    }

    fallback() external payable {}

    receive() external payable {}

    function deposit(uint256 amount) public {
        require(amount > 0, "amount is 0");
        require(base.allowance(msg.sender, address(this)) >= amount, "allowance not enough");

        base.transferFrom(msg.sender, address(this), amount);

        userDeposit[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "amount is 0");
        uint256 depositAmount = userDeposit[msg.sender];
        require(depositAmount >= amount, "insufficient deposit balance");

        userDeposit[msg.sender] = depositAmount - amount;

        base.transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }
}
