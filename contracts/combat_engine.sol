// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./IERC721.sol";
import "./rarity_library.sol";
import "./rarity_interfaces.sol";
import "./rarity_structs.sol";
import "./lcgRandomGenerator.sol";

// Contract of each fight
contract combat_engine {
    struct Player {
        uint256 id;
        rl._ability_scores attr;
        uint8 class;
        uint32 health;
        uint8 armorclass;
        uint8[6] modifiers;
        uint8[20] abilities;
        bool ready;
    }

    enum Classes {
        Barbarian,
        Bard,
        Cleric,
        Druid,
        Fighter,
        Monk,
        Paladin,
        Ranger,
        Rouge,
        Sorcerer,
        Wizard
    }

    enum AbilityCheck {
        // _str
        Athletics,
        // _dex
        Acrobatics,
        Sleight,
        Stealth,
        // _int
        Arcana,
        History,
        Investigation,
        Nature,
        Religion,
        // _wis
        AnimalHandling,
        Insight,
        Medicine,
        Perception,
        Survival,
        // _cha
        Deception,
        Intimidation,
        Performance,
        Persuasion,
        // Others
        Health,
        ArmorClass
    }
    uint8[21] check_type = [
        0,
        1,
        1,
        1,
        3,
        3,
        3,
        3,
        3,
        4,
        4,
        4,
        4,
        4,
        5,
        5,
        5,
        5,
        2, // Health : Constition
        1 // _dex / AC
    ];

    uint256 m = 2**16 + 1;
    lcgRandomGenerator zx81;

    // Events
    event Rolled(uint256 player, uint256 value);

    constructor() {
        zx81 = new lcgRandomGenerator(m, 75, 74, block.number);
    }

    // Randomness
    function random(uint256 min, uint256 max) public returns (uint256 rand) {
        require(max < m);
        rand = min + (zx81.next() % (max - min));
    }

    function roll_general(
        uint256 n,
        uint256 step,
        uint256 min
    ) public returns (uint256) {
        // n sided dice with increments of step, and min value min
        return min + step * random(0, n - 1);
    }

    function roll_dn(uint256 n) public returns (uint256 val) {
        val = 1 + (zx81.next() % n);
    }

    function roll(uint256 id, uint256 n) public returns (uint256 val) {
        val = 1 + (zx81.next() % n);
        emit Rolled(id, val);
    }

    // Calculate attributes
    function attackModifierByClass(
        Classes class,
        uint256 level,
        rl._ability_scores memory attr
    ) internal pure returns (uint256 val) {
        if (class == Classes.Barbarian) {
            val = attr._str / 2;
        } else if (class == Classes.Bard) {
            val = (attr._cha + attr._str + attr._wis) / 6;
        } else if (class == Classes.Cleric) {
            val = (attr._int + attr._con) / 4;
        } else if (class == Classes.Druid) {
            val = (attr._wis + attr._str) / 4;
        } else if (class == Classes.Fighter) {
            val = (attr._dex + attr._con) / 4;
        } else if (class == Classes.Monk) {
            val = (attr._str + attr._int) / 4;
        } else if (class == Classes.Paladin) {
            val = (attr._str + attr._con + attr._int) / 6;
        } else if (class == Classes.Ranger) {
            val = attr._dex / 2;
        } else if (class == Classes.Rouge) {
            val = (attr._str + attr._dex) / 4;
        } else if (class == Classes.Sorcerer) {
            val = (attr._cha + attr._int) / 4;
        } else if (class == Classes.Wizard) {
            val = attr._int / 2;
        }
        val += level;
    }

    // Combat actions
    // get modifiers based on class

    function basicAttack(Player memory p) public pure returns (uint32) {
        return 0;
    }

    function takeDamage(Player memory p, uint32 damage)
        public
        pure
        returns (uint256)
    {
        //
        return 0;
    }

    function skillRoll(Player memory p, AbilityCheck a)
        public
        returns (uint256 val)
    {
        // _str modifier
        val =
            roll_dn(20) +
            p.modifiers[check_type[uint8(a)]] +
            p.abilities[uint8(a)];
    }

    function skillCheck(
        Player memory p,
        uint8 dc,
        AbilityCheck a
    ) public returns (bool) {
        return (dc >= skillRoll(p, a));
    }
}
