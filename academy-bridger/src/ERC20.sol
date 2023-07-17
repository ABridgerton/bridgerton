// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20 {
    constructor() ERC20("ABridger", "ABr") {
        this;
    }
}
