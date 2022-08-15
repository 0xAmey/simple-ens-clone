// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract ENS {
    error ENS__Unauthorised();
    error ENS__AlreadyRegistered();

    mapping(string => address) public nameToAddress;

    function register(string memory name) public payable {
        if (nameToAddress[name] != address(0)) revert ENS__AlreadyRegistered();
        nameToAddress[name] = msg.sender;
    }

    function update(string memory name, address addr) public payable {
        if (msg.sender != nameToAddress[name]) revert ENS__Unauthorised();
        nameToAddress[name] = addr;
    }
}
