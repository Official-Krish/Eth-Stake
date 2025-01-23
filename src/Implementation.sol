
// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

interface IOrcaToken {
    function mint(address to, uint256 amount) external;
}

contract StakeContract {
    uint256 public totalStaked;
    IOrcaToken public orcaToken;

    struct Info {
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 lastUpdate;
    }
    mapping(address => Info) public stakerInfo;

    uint256 public constant rewardRate = 1;
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    constructor() {
    }

    function updateRewards(address _address) internal {
        Info storage user = stakerInfo[_address];

        if(user.lastUpdate == 0) {
            user.lastUpdate = block.timestamp;
            return;
        }
        uint timeElapsed = block.timestamp - user.lastUpdate;
        if(timeElapsed == 0) {
            return;
        }

        uint256 reward = (user.stakedAmount * timeElapsed) * rewardRate;
        user.rewardDebt += reward;
        user.lastUpdate = block.timestamp;
    }

    function stake(uint256 _amount) public payable {
        uint amount = msg.value;
        require(amount > 0, "Amount must be greater than 0");
        require(amount == _amount, "Amount must be equal to msg.value");
        updateRewards(msg.sender);
        totalStaked += amount;
        stakerInfo[msg.sender].stakedAmount += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= stakerInfo[msg.sender].stakedAmount, "Amount must be less than or equal to staked amount");
        updateRewards(msg.sender);
        totalStaked -= amount;
        stakerInfo[msg.sender].stakedAmount -= amount;
        payable(msg.sender).transfer(amount);
        emit Unstaked(msg.sender, amount);
    }

    function getRewards(address _address) public view returns (uint256) {
        uint timeElapsed = block.timestamp - stakerInfo[_address].lastUpdate;
        if(timeElapsed == 0) {
            return 0;
        }
        return (stakerInfo[_address].stakedAmount * timeElapsed) * rewardRate + stakerInfo[_address].rewardDebt;
    }

    function claimRewards() public {
        updateRewards(msg.sender);
        uint256 reward = stakerInfo[msg.sender].rewardDebt;
        orcaToken.mint(msg.sender, reward);
        stakerInfo[msg.sender].rewardDebt = 0;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return stakerInfo[_address].stakedAmount;
    }

}