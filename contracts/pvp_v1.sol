// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./combat_engine.sol";

// Contract of each fight
contract pvp_arena is Ownable {
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
        uint256 numPlayers;
        //uint256[] players;
        mapping(uint256 => uint256) players;
        //mapping(uint256 => bool) player_ready;
        uint256 readyCount;
        uint256 prize_money;
    }

    event NewMatch(uint256 matchId, address indexed host);
    event JoinedMatch(uint256 matchId, uint256 tokenId);
    event StartingMatch(uint256 matchId, uint256 numPlayers);
    event Winner(uint256 matchId, uint256 tokenId);

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
        address own = rarity_nft.ownerOf(id);
        return ((own == sender) ||
            rarity_nft.isApprovedForAll(own, sender) ||
            (sender == rarity_nft.getApproved(id)));
    }

    // Utility functions

    // Core
    function newMatch(uint256 _bet_amount, uint256 _numPlayers)
        public
        payable
        returns (uint256)
    {
        require(_bet_amount < MAX_BET, "Cannot be more than 10 FTM");
        payable(owner()).transfer(ante);
        Match storage mat = match_records[match_count];
        mat.host = msg.sender;
        mat.bet = _bet_amount;
        mat.numPlayers = _numPlayers;
        //mat.readyCount = 0;
        //mat.prize_money = 0;
        match_count += 1;
        emit NewMatch(match_count - 1, msg.sender);
        return match_count - 1;
    }

    function joinMatch(uint256 matchId, uint256 id) public payable {
        require(check_approved(id, msg.sender), "Are you the owner?");
        require(match_count > matchId, "No such match");

        Match storage mat = match_records[matchId];
        require(msg.value >= mat.bet, "Don't be cheap on the bet");
        require(mat.finished == false, "Match is already over");

        mat.players[mat.readyCount] = id;
        mat.readyCount += 1;
        mat.prize_money += mat.bet;
        emit JoinedMatch(matchId, id);

        if (mat.numPlayers == mat.readyCount) {
            startFight(matchId, mat);
        }
    }

    function fight(uint256 matchId) public {
        require(match_count > matchId, "No such match");
        // Allow host to launch a match with fewer people
        Match storage mat = match_records[matchId];
        if (mat.readyCount > 1 && msg.sender == mat.host) {
            if (mat.readyCount != mat.numPlayers) {
                mat.numPlayers = mat.readyCount;
            }
            startFight(matchId, mat);
        } else {
            revert("Cannot start match, not enough players");
        }
    }

    function startFight(uint256 matchId, Match storage mat)
        internal
        returns (uint256 winner)
    {
        require(mat.finished == false, "Match is already over");
        emit StartingMatch(matchId, mat.numPlayers);
        uint256 seed = block.timestamp;
        winner = ce.roll_dn(mat.numPlayers);
        emit Winner(matchId, winner);

        mat.finished = true;
    }
    // Turnwise fighting
    // for each, find the ability that will do the max damage
    // use it to attack
}
