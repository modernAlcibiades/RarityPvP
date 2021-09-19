# PvP for Rarity
This project focuses on developing a functional engine for stepwise roleplay like traditional RPGs. The first step is a basic PvP abilities.

DONE
- A crowd-based on-chain random number generator which will become more difficult to spoof as the number of independent games increase.
- Basic combat engine interface
- PvP arena setup

TO DO
- Integration with off-chain source of randomness
- Pan out combat engine
- Add skills and feats
- Add time and movement dimension

# Contracts for PvP Arena

## lcgRandomGenerator
Random Generator designed to write on-chain. DO NOT USE IN CRITICAL APPLICATIONS.
Idea : Updates the contract state and outputs a random number. The random number generator when used by a lot of applications can be said to be pseudo random. The miner still has some control over the random numbers, and the future values can be predicted. Still, useable for current version, until it is augmented with Chainlink VRF in future versions

## combat_engine
All the default settings for combat mechanics are in this contract. Currently, it is at version 0, only basic attacks are implemented as a POC. Skills haven't been added yet.

## pvp_arena
Arena where new matches can be created and hosted. Stores the results all previous matches. Should be updated with proper proxy contract formalism and delegate calls. Later of course.
