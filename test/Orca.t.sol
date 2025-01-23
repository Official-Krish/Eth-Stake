// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/OrcaToken.sol";

contract OrcaTest is Test {
    OrcaToken orca;
    address deployer = address(0x69);

    function setUp() public {
        orca = new OrcaToken();
    }

    function testInitialSupply() public {
        assertEq(orca.totalSupply(), 0);
    }

    function testMint() public {
        orca.setContractAddress(address(this));
        orca.mint(deployer, 100);
        assertEq(orca.totalSupply(), 100);
        assertEq(orca.balanceOf(deployer), 100);
    }

    function testBurn() public {
        orca.setContractAddress(address(this));
        orca.mint(deployer, 100);
        orca.burn(deployer, 50);
        assertEq(orca.totalSupply(), 50);
        assertEq(orca.balanceOf(deployer), 50);
    }

    function testFailMint() public {
        orca.mint(deployer, 100);
    }

    function testFailBurn() public {
        orca.burn(deployer, 100);
    }

    function testFailSetContractAddress() public {
        vm.prank(deployer);
        orca.setContractAddress(address(0x69));
    }
}