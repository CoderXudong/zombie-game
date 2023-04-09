// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.4.20;

import "./zombiefactory.sol";

// Defines an interface for interacting with the CryptoKitties smart contract.
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

// A contract that allows zombies to feed on other creatures
contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContact;

    // Sets the address of the KittyInterface contract
    function setKittyInterfaceAddress(address _address) external onlyOwner {
        kittyContact = KittyInterface(_address);
    }

    // Feeds a zombie with a target DNA and multiplies their DNA to create a new zombie
    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
    }

    // Feeds a zombie on a kitty
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, _kittyId, "kitty");
    }

}
