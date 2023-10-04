//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../../src/FundMe.sol";

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe} from "../../script/Interaction.s.sol";

contract FundMeIntegrationTest is Test {
    
    FundMe fundMe;
    address USER = makeAddr("User");
    uint256 STARTING_BALANCE = 10 ether;
    uint256 SEND_VALUE = 0.1 ether;
    uint256 GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testUserCanFundInteraction() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.prank(USER);
        vm.deal(USER, STARTING_BALANCE);

        fundFundMe.FundLatestFundMe(address(fundMe));

        address funders = fundMe.getFunders(0);
        assertEq(funders, USER);
    }
}
