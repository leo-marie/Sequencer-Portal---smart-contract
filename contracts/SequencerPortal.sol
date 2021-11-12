// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SequencerPortal {
    uint256 totalSequences;
    uint256 private seed; // for random number

    event NewSequence(address indexed from, uint256 timestamp, string sequence);

    // A struct is basically a custom datatype where we can customize what we want to hold inside it.
    struct Sequence {
        address musician; // The address of the user who saved.
        string sequence; // The sequence the user saved.
        uint256 timestamp; // The timestamp when the user saved.
    }
    /*
     * I declare a variable sequences that lets me store an array of structs.
     * This is what lets me hold all the sequences anyone ever sends to me!
     */
    Sequence[] sequences;
    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastSavedAt;

    constructor() payable { // constructor runs during deploy
        console.log("I am in SC constructor and should run only once");
    }

    function saveSequence(string memory _sequence) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastSavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30s"
        );
        /*
         * Update the current timestamp we have for the user
         */
        lastSavedAt[msg.sender] = block.timestamp;

        totalSequences += 1; /* !!!! Replace with React state */
        console.log("%s saved a sequence !", msg.sender);
        /*
         * This is where I actually store the sequence data in the array.
         */
        sequences.push(Sequence(msg.sender, _sequence, block.timestamp));
        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;
        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(                                                      // check if true, if false it exits the function and cancel tx
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}(""); // send money
            require(success, "Failed to withdraw money from contract."); 
        } // if seed < 50

        emit NewSequence(msg.sender, block.timestamp, _sequence);
    } // saveSequence

    /*
     * I added a function getAllSequences which will return the struct array, sequences, to us.
     * This will make it easy to retrieve the sequences from our website!
     */
    function getAllSequences() public view returns (Sequence[] memory) {
        return sequences;
    }

    function getTotalSequences() public view returns (uint256) {
        console.log("We have %d total sequences!", totalSequences);
        return totalSequences;
    }
} // contract