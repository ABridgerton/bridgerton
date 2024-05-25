// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IWrappedABridgerToken} from "./interfaces/ITokens.sol";

abstract contract WrappedABridgerToken is
    IWrappedABridgerToken,
    ERC20,
    Ownable
{
    constructor() ERC20("Wrapped ABridger Token", "WABR") {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
