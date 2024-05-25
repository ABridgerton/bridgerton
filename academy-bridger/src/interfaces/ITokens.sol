// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IABridgerToken {
    function mint(address to, uint256 amount) external;

    function burn(address from, uint256 amount) external;
}

interface IWrappedABridgerToken {
    function mint(address to, uint256 amount) external;

    function burn(address from, uint256 amount) external;
}
