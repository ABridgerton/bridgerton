// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {BridgertonScript} from "../script/BridgertonScript.s.sol";
import "forge-std/Test.sol";

contract BridgertonScriptTest is Test {
    BridgertonScript public bridgeScript;

    function setUp() public {
        bridgeScript = new BridgertonScript();
    }

    function test_run() public {
        bridgeScript.run();

        assertTrue(true, "The test script suit is set up correctly and the run function executed.");
    }
}
