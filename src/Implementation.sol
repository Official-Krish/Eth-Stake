
// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakeContract {
    uint256 public totalStaked;
    mapping(address => uint256) public stakedAmount;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    constructor() {
    }

    function stake(uint256 _amount) public payable {
        uint amount = msg.value;
        require(amount > 0, "Amount must be greater than 0");
        require(amount == _amount, "Amount must be equal to msg.value");
        totalStaked += amount;
        stakedAmount[msg.sender] += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= stakedAmount[msg.sender], "Amount must be less than or equal to staked amount");
        payable(address(msg.sender)).transfer(amount);
        totalStaked -= amount;
        stakedAmount[msg.sender] -= amount;
        emit Unstaked(msg.sender, amount);
    }


}