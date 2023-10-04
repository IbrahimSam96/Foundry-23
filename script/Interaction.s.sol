//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {


    function FundLatestFundMe(address fundMeAddress) public {
        FundMe(payable(fundMeAddress)).fund{value: 5e18}();
        console.log("Funded -> FundMe");
    }

    function run() external {
        address mostRecentDeployedFundMe = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();

        FundLatestFundMe(mostRecentDeployedFundMe);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {}

