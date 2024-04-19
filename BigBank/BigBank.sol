// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner;

    mapping(address => uint256) public userDeposit;

    address[3] public userRank;

    constructor() {}

    fallback() external payable {}

    receive() external payable {
        _deposit(msg.value);
    }

    function deposit() public payable virtual {
        _deposit(msg.value);
    }

    function _deposit(uint256 amoount) internal {
        if (amoount == 0) {
            return;
        }

        userDeposit[msg.sender] += amoount;

        uint256 depositAmount = userDeposit[msg.sender];

        if (depositAmount > userDeposit[userRank[2]]) {
            if (depositAmount > userDeposit[userRank[0]]) {
                if (userRank[1] != msg.sender) {
                    //msg.sender不为第二名时，1-3名重排
                    userRank[2] = userRank[1];
                    userRank[1] = userRank[0];
                    userRank[0] = msg.sender;
                } else {
                    //msg.sender为第二名时，对调一二名位置即可
                    userRank[1] = userRank[0];
                    userRank[0] = msg.sender;
                }
            } else if (depositAmount > userDeposit[userRank[1]]) {
                //msg.sender为第一名时，排名不变
                if (userRank[0] != msg.sender) {
                    //msg.sender不为第一名时，2-3名重排
                    userRank[2] = userRank[1];
                    userRank[1] = msg.sender;
                }
            } else {
                //msg.sender为第二名时，排名不变
                if (userRank[1] != msg.sender) {
                    //msg.sender不为第二名时，第三名更换为msg.sender
                    userRank[2] = msg.sender;
                }
            }
        }
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
}

contract BigBank is Bank {
    modifier minDeposit(uint256 amount) {
        require(amount > 0.001 ether, "Below the minimum amount");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable override minDeposit(msg.value) {
        _deposit(msg.value);
    }

    function transferOwner(address _newOwner) public {
        require(msg.sender == owner, "Not owner");
        require(_newOwner != address(0), "0 address");

        owner = _newOwner;
    }
}

interface IBigBank {
    function withdraw(uint256 amount) external;

    function transferOwner(address _newOwner) external;
}

contract Ownable {
    IBigBank bigBank;

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _bigBank) {
        bigBank = IBigBank(payable(_bigBank));
        owner = msg.sender;
    }

    receive() external payable {}

    function withdraw(uint256 amount) public onlyOwner {
        bigBank.withdraw(amount);
        payable(msg.sender).transfer(amount);
    }

    function transferBigBankOwner(address _newOwner) public onlyOwner {
        bigBank.transferOwner(_newOwner);
    }
}
