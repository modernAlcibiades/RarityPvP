// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// An attempt at crowdsourced randomness
// linear_congruential_generator
// x = ax+c mod m;
// m prime
// m can be anything, but prime values preferred
import "@openzeppelin/contracts/access/Ownable.sol";

contract lcgRandomGenerator is Ownable {
    uint256 public a;
    uint256 public c;
    uint256 public m;
    uint256 public x;
    mapping(address => bool) public approved;

    constructor(
        uint256 _m,
        uint256 _a,
        uint256 _c,
        uint256 _seed
    ) {
        require(_a > _m && _a < _m && _c < _m);
        a = _a;
        c = _c;
        m = _m;
        x = _seed;
        // Approve owner
        approved[msg.sender] = true;
    }

    function next() public returns (uint256) {
        require(approved[msg.sender]);
        x = (a * x + c) % m;
        return x;
    }

    function approve(address addr) external onlyOwner {
        approved[addr] = true;
    }

    function disapprove(address addr) external onlyOwner {
        delete (approved[addr]);
    }
}
