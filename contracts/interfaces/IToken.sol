// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

interface IToken is IERC20 {
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
}