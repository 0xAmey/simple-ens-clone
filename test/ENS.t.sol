// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "../src/ENS.sol";

contract ENSTest is Test {
    address public user;
    ENS public ens;

    //Vm public vm;

    function setUp() public {
        ens = new ENS();
        user = makeAddr("user");
        //vm = new Vm();
    }

    function testCanRegister() public {
        assertEq(ens.nameToAddress("test"), address(0));
        ens.register("test");
        assertEq(ens.nameToAddress("test"), address(this));
    }

    function testCannotRegisterExistingName() public {
        ens.register("test");
        assertEq(ens.nameToAddress("test"), address(this));

        vm.prank(user);
        vm.expectRevert(abi.encodeWithSignature("ENS__AlreadyRegistered()"));
        ens.register("test");

        assertEq(ens.nameToAddress("test"), address(this));
    }

    function testCanUpdate() public {
        ens.register("test");
        assertEq(ens.nameToAddress("test"), address(this));

        ens.update("test", user);
        assertEq(ens.nameToAddress("test"), user);
    }

    function testNonOwnerCannotUpdate() public {
        ens.register("test");
        assertEq(ens.nameToAddress("test"), address(this));

        vm.prank(user);
        vm.expectRevert(abi.encodeWithSignature("ENS__Unauthorised()"));
        ens.update("test", user);

        assertEq(ens.nameToAddress("test"), address(this));
    }
}
