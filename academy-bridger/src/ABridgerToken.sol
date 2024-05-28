// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IABridgerToken} from "./interfaces/ITokens.sol";

contract ABridgerToken is IABridgerToken, ERC20, Ownable {
    constructor() Ownable(msg.sender) ERC20("ABridger Token", "ABR") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
