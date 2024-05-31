// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import {ABridgerToken} from "../src/ABridgerToken.sol";

contract ABridgerTokenTest is Test {
    ABridgerToken private token;
    address private owner;
    address private user = address(1);
    uint256 mintAmount = 1000;
    uint256 burnAmount = 500;

    function setUp() public {
        owner = msg.sender;
        token = new ABridgerToken();

        token.mint(user, mintAmount);
    }

    function test_initialBalance() public {
        assertEq(token.balanceOf(user), mintAmount);
    }

    function test_mint() public {
        token.mint(user, mintAmount);
        assertEq(token.balanceOf(user), mintAmount);
    }

    function test_burn() public {
        token.burn(user, burnAmount);
        assertEq(token.balanceOf(user), burnAmount);
    }
}
