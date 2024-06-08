// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import {ABridgerToken} from "../src/ABridgerToken.sol";
import {Bridgerton} from "../src/Bridgerton.sol";
import {BridgertonScript} from "../script/BridgertonScript.s.sol";

contract BridgertonScript is Script {
    ABridgerToken public mainToken;
    Bridgerton public bridge;

    function run() public {
        vm.startBroadcast();

        // Deploy the main token
        mainToken = new ABridgerToken();
        console.log("MainToken deployed at:", address(mainToken));

        // Deploy the bridge
        bridge = new Bridgerton();
        console.log("Bridge deployed at:", address(bridge));

        vm.stopBroadcast();
    }
}
