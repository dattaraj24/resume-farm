// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Resumee is ERC20 {
    constructor() ERC20("resume", "resume") {}

    function mint(address to, uint256 amount) public{
        _mint(to, amount);
    }
}