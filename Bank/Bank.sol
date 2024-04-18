// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner;

    mapping(address => uint256) public userDeposit;

    address[3] public userRank;

    uint256[3] public depositRank;

    constructor() {
        owner = msg.sender;
    }

    fallback() external payable {}

    receive() external payable {
        if (msg.value == 0) {
            return;
        }

        userDeposit[msg.sender] += msg.value;

        uint256 totalDeposit = userDeposit[msg.sender];

        if (totalDeposit > depositRank[2]) {
            if (totalDeposit > depositRank[0]) {
                if (userRank[0] == msg.sender) {
                    depositRank[0] = totalDeposit;
                } else if (userRank[1] == msg.sender) {
                    depositRank[1] = depositRank[0];
                    depositRank[0] = totalDeposit;

                    userRank[1] = userRank[0];
                    userRank[0] = msg.sender;
                } else {
                    depositRank[2] = depositRank[1];
                    depositRank[1] = depositRank[0];
                    depositRank[0] = totalDeposit;

                    userRank[2] = userRank[1];
                    userRank[1] = userRank[0];
                    userRank[0] = msg.sender;
                }
            } else if (totalDeposit > depositRank[1]) {
                if (userRank[1] == msg.sender) {
                    depositRank[1] = totalDeposit;
                } else {
                    depositRank[2] = depositRank[1];
                    depositRank[1] = totalDeposit;

                    userRank[2] = userRank[1];
                    userRank[1] = msg.sender;
                }
            } else if (userRank[1] != msg.sender) {
                if (userRank[1] == msg.sender) {
                    depositRank[1] = totalDeposit;
                } else {
                    depositRank[2] = totalDeposit;

                    userRank[2] = msg.sender;
                }
            }
        }
    }

    function deposit() public payable {
        if (msg.value == 0) {
            return;
        }

        userDeposit[msg.sender] += msg.value;

        uint256 totalDeposit = userDeposit[msg.sender];

        if (totalDeposit > depositRank[2]) {
            if (totalDeposit > depositRank[0]) {
                if (userRank[0] == msg.sender) {
                    depositRank[0] = totalDeposit;
                } else if (userRank[1] == msg.sender) {
                    depositRank[1] = depositRank[0];
                    depositRank[0] = totalDeposit;

                    userRank[1] = userRank[0];
                    userRank[0] = msg.sender;
                } else {
                    depositRank[2] = depositRank[1];
                    depositRank[1] = depositRank[0];
                    depositRank[0] = totalDeposit;

                    userRank[2] = userRank[1];
                    userRank[1] = userRank[0];
                    userRank[0] = msg.sender;
                }
            } else if (totalDeposit > depositRank[1]) {
                if (userRank[1] == msg.sender) {
                    depositRank[1] = totalDeposit;
                } else {
                    depositRank[2] = depositRank[1];
                    depositRank[1] = totalDeposit;

                    userRank[2] = userRank[1];
                    userRank[1] = msg.sender;
                }
            } else if (userRank[1] != msg.sender) {
                if (userRank[1] == msg.sender) {
                    depositRank[1] = totalDeposit;
                } else {
                    depositRank[2] = totalDeposit;

                    userRank[2] = msg.sender;
                }
            }
        }
    }

    function updateOwner(address _newOwner) public {
        require(msg.sender == owner, "Not owner");
        require(_newOwner != address(0), "0 address");

        owner = _newOwner;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Not owner");

        if (amount > address(this).balance) {
            amount = address(this).balance;
        }

        payable(msg.sender).transfer(amount);
    }

    function getUserRank() public view returns (address[3] memory) {
        return userRank;
    }

    function getDepositRank() public view returns (uint256[3] memory) {
        return depositRank;
    }
}
