// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.4.20;

import "./ownable.sol";

contract ZombieFactory is Ownable{

    // Event that is triggered when a new zombie is created
    event NewZombie(uint zombieId, string name, uint dna);

    // Variables to determine the number of digits in DNA and DNA modulus
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // Public mapping to store the owner of each zombie
    mapping(uint => address) public zombieToOwner;
    // Public mapping to store the number of zombies owned by each address
    mapping(address => uint) ownerZombieCount;

    // Struct to define the properties of a zombie
    struct Zombie {
        string name;
        uint dna;
    }

    // Public array to store all zombies
    Zombie[] public zombies;

    // Internal function to create a new zombie with a given name and DNA
    function _createZombie(string _name, string _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    // Internal function to generate a random DNA using a string input
    function  _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    // Public function to create a new zombie with a given name and random DNA
    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
