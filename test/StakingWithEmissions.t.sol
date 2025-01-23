// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ProxyContract.sol";
import "../src/OrcaToken.sol";
import "../src/Implementation.sol";

contract StakingWithEmissionsTest is Test {
    ProxyContract c;
    OrcaToken orcaToken;
    StakeContract stakingContract;

    function setUp() public {
        orcaToken = new OrcaToken(address(this));
        stakingContract = new StakeContract();
        c = new ProxyContract(address(stakingContract), IOrcaToken(address(orcaToken)));
        orcaToken.setContractAddress(address(c));
    }

    function testStake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        assert(c.totalStaked() == value);
    }

    function testUnstake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        assert(c.totalStaked() == value);
        c.unstake(value);
        assert(c.totalStaked() == 0);
    }

    function testGetRewards() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        assert(c.totalStaked() == value);
        vm.warp(block.timestamp + 1);
        uint rewards = c.getRewards(address(this));

        assert(rewards == 1 ether);
    }

    function testClaimRewards() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        assert(c.totalStaked() == value);
        vm.warp(block.timestamp + 1);
        uint rewards = c.getRewards(address(this));
        c.claimRewards();
        assert(c.totalStaked() == value);
        assert(orcaToken.balanceOf(address(this)) == rewards);
    }
}