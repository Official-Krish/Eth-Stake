// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OrcaToken is ERC20 {
    address public ContractAddress;
    address public owner;

    constructor(address _contractAddress) ERC20("Orca Token", "ORCA") {
        owner = msg.sender;
        ContractAddress = _contractAddress;
    }

    modifier onlyContract() {
        require(msg.sender == ContractAddress, "Only contract can call this function");
        _;
    }

    function setContractAddress(address _contractAddress) public {
        require(msg.sender == owner, "Only owner can set contract address");
        ContractAddress = _contractAddress;
    }

    function mint(address to, uint256 amount) external onlyContract{
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
}
