// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.4.20;

contract Ownable {

    // Public address variable to store the owner's address
    address public owner;

    // Event that is triggered when ownership is transferred
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Constructor function that sets the contract creator as the initial owner
    function Ownable() public {
        owner = msg.sender;
    }

    // Modifier function that restricts access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Function to transfer ownership of the contract
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}
