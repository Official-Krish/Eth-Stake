// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

interface IOrcaToken {
    function mint(address to, uint256 amount) external;
}

contract ProxyContract {
    uint256 public totalStaked;
    IOrcaToken public orcaToken;

    struct Info {
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 lastUpdate;
    }
    mapping(address => Info) public stakerInfo;

    address public implementation;

    constructor(address _implementation, IOrcaToken tokenAddress) {
        implementation = _implementation;
        orcaToken = tokenAddress;
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
