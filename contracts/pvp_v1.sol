// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./combat_engine.sol";

// Contract of each fight
contract arena_1v1 is Ownable {
    using Strings for uint256;
    using Strings for int256;

    // TODO add debuffs
    // TODO add skills

    uint256 public constant MAX_PLAYERS = 2;
    uint256 public constant MAX_BET = 100 ether;
    IERC721 rarity_nft = IERC721(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);

    struct Match {
        address host;
        bool finished;
        uint256 winner;
        uint256 bet;
        uint256 num_players;
        uint256[] players;
        //mapping(uint256 => bool) player_ready;
        uint256 ready_count;
        uint256 prize_money;
    }

    event StartingMatch(uint256 matchid, uint256 num_players);

    mapping(uint256 => Match) match_records;
    uint256 match_count;
    combat_engine ce;
    uint256 ante = 0.1 ether;

    constructor() {
        match_count = 0;
        ce = new combat_engine();
    }

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
    function newMatch(uint256 _bet_amount, uint256 _num_players)
        public
        payable
        returns (uint256)
    {
        require(_bet_amount < MAX_BET);
        this.owner.transfer(ante);

        Match mat = new Match({
            host: msg.sender,
            finished: false,
            winner: 0,
            bet: _bet_amount,
            num_players: _num_players,
            players: new uint256[_num_players],
            prize_money: 0
        });
        match_records[match_count] = mat;
        match_count += 1;
    }

    function join(uint256 match_id, uint256 id) public payable {
        require(check_approved(id, msg.sender));
        require(match_count > match_id);
        Match storage mat = match_records[match_id];
        this.transfer(mat.bet);
        mat.players[mat.ready_count] = id;
        mat.ready_count += 1;
        mat.prize_money += mat.bet;
    }

    function fight(uint256 match_id) public {
        require(match_count > match_id);
        // Allow owner to launch a match with fewer people
        Match storage mat = match_records[match_id];
        if (mat.ready_count > 1 && msg.sender == owner) {
            if (mat.ready_count != mat.num_players) {
                mat.num_players = mat.ready_count;
            }
            start_fight(match_id, mat);
        } else if (mat.ready_count == mat.num_players) {
            start_fight(match_id, mat);
        } else {
            revert("Cannot start match, not enough players");
        }
    }

    function start_fight(uint256 match_id, Match storage mat)
        internal
        returns (uint256 winner)
    {
        emit StartingMatch(match_id, mat.num_players);
        winner = ce.roll_dn(mat.num_players);
    }
    // Turnwise fighting
    // for each, find the ability that will do the max damage
    // use it to attack
}
