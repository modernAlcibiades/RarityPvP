// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./combat_engine.sol";

// Contract of each fight
contract arena_1v1 is IERC721 {
    using Strings for uint256;
    using Strings for int256;

    // TODO add debuffs
    // TODO add skills

    uint256 public constant MAX_PLAYERS = 2;
    uint256 public constant MAX_BET = 100 ether;
    IERC721 rarity_nft = IERC721(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);

    uint256[2] public players; //token id of summoners
    uint256 public bet;
    mapping(uint256 => Player) stats;
    combat_engine ce;

    // Checks and utils
    function check_approved(uint256 id, address sender)
        public
        view
        returns (bool)
    {
        address owner = rarity_nft.ownerOf(id);
        return ((owner == sender) ||
            rarity_nft.isApprovedForAll(owner, sender) ||
            (sender == rarity_nft.getApproved(id)));
    }

    // Utility functions

    // Core
    constructor(uint256 _bet_amount, uint256[2] memory ids) {
        require(_bet_amount < MAX_BET);
        bet = _bet_amount;
        players = ids;
        ce = new combat_engine();
    }

    function join(uint256 id) external payable {
        require(check_approved(id, msg.sender));
        require(msg.value >= bet && msg.value <= MAX_BET);
    }

    function fight() internal {}

    // Turnwise fighting
    // for each, find the ability that will do the max damage
    // use it to attack
}
