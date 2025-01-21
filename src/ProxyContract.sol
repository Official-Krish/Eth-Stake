// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract ProxyContract {
    uint256 public totalStaked;
    mapping(address => uint256) public stakedAmount;
    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function setImplementation(address _implementation) public {
        implementation = _implementation;
    }

    fallback() external payable {
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success, "delegatecall failed");
    }
    
    receive() external payable {}
    
}
