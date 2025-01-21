// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/ProxyContract.sol";
import "src/Implementation.sol";

contract StakeContractTest is Test {
    ProxyContract c;
    StakeContract stakingContract;

    function setUp() public {
        stakingContract = new StakeContract();
        c = new ProxyContract(address(stakingContract));
    }

    function testStake() public {
        uint value = 10 ether;
        vm.deal(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f, value);
        vm.startPrank(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f);
        
        // Call stake through proxy
        (bool success, ) = address(c).call{value: value}(
            abi.encodeWithSignature("stake(uint256)", value)
        );
        assert(success);
        
        // Call totalStaked through proxy
        (bool success2, bytes memory data) = address(c).call(
            abi.encodeWithSignature("totalStaked()")
        );
        assert(success2);
        uint currentStake = abi.decode(data, (uint256));
        assert(currentStake == value);
        vm.stopPrank();
    }

    function testUnstake() public {
        uint value = 10 ether;
        vm.deal(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f, value);
        vm.startPrank(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f);
        
        // Stake through proxy
        (bool success, ) = address(c).call{value: value}(
            abi.encodeWithSignature("stake(uint256)", value)
        );
        assert(success);
        
        // Check total staked through proxy
        (bool success2, bytes memory data) = address(c).call(
            abi.encodeWithSignature("totalStaked()")
        );
        assert(success2);
        uint currentStake = abi.decode(data, (uint256));
        assert(currentStake == value);
        
        // Unstake through proxy
        (bool success3, ) = address(c).call(
            abi.encodeWithSignature("unstake(uint256)", value)
        );
        assert(success3);
        
        // Check final total staked through proxy
        (bool success4, bytes memory data2) = address(c).call(
            abi.encodeWithSignature("totalStaked()")
        );
        assert(success4);
        uint currentStake2 = abi.decode(data2, (uint256));
        assert(currentStake2 == 0);
        vm.stopPrank();
    }
}
