//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../../src/FundMe.sol";

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address User = makeAddr("user");
    uint256 constant StartBalance = 5 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        // Send 5 ETH to the User
        vm.deal(User, StartBalance);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundMeIsWhithoutEther() public {
        vm.expectRevert(); // Hey, I expect a revert
        fundMe.fund();
    }

    function testFundedAmount() public {
        vm.prank(User); // The next TX will be sent by USER

        fundMe.fund{value: 5e18}();

        uint256 fundedAmount = fundMe.getAddrressToAmountFunded(User);

        assertEq(fundedAmount, 5e18);
    }

    modifier fundedByUser() {
        vm.prank(User); // The next TX will be sent by USER
        fundMe.fund{value: 5e18}();
        _;
    }

    function testUserFunderAdded() public fundedByUser {
        address funders = fundMe.getFunders(0);
        assertEq(funders, User);
    }

    function testOnlyOwnerWithdraw() public fundedByUser {
        // Act
        vm.expectRevert(); // Hey, I expect a revert
        fundMe.withdraw();
    }
}
