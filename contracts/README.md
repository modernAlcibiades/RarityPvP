# Contracts for PvP Arena

## lcgRandomGenerator
Random Generator designed to write on-chain. DO NOT USE IN CRITICAL APPLICATIONS.
Idea : Updates the contract state and outputs a random number. The random number generator when used by a lot of applications can be said to be pseudo random. The miner still has some control over the random numbers, and the future values can be predicted. Still, useable for current version, until it is augmented with Chainlink VRF in future versions

## combat_engine
All the default settings for combat mechanics are in this contract. Currently, it is at version 0, only basic attacks are implemented as a POC. Skills haven't been added yet.

---------------------------
## Interfaces / library contracts from https://github.com/andrecronje/rarity

> Library Contract: 0xa1364d81d86e88cfD018CCa4ac239A997dc96F31
## Library
> rarity_library.sol

Offers functions to fetch aggregated data for summoners and items. Can be used by other smart contracts or UIs. 
For example to load all summoner data for multiple summoners: 
```
>>> library.summoners_full([466576, 466591])

((('Conan', 750000000000000000000, 1631556199, 1, 2), ((18, 14, 14, 10, 10, 8), (4, 2, 2, 0, 0, -1), 32, 32, True), ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (Fals
e, False, False, True, False, True, False, False, False, False, False, False, False, True, False, False, True, True, False, True, False, False, False, False, True, False, False, False, False, False, False, True, True, False, False,
False), 20, 0), (0, 1000000000000000000000, 0), ((40, 8),)), (('Wulfgar', 750000000000000000000, 1631556199, 1, 2), ((18, 14, 14, 10, 10, 8), (4, 2, 2, 0, 0, -1), 32, 32, True), ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (False, False, False, True, False, True, False, False, False, False, False, False, False, True, False, False, True, True, False, True, False, False, False, False, True, False,
 False, False, False, False, False, True, True, False, False, False), 20, 0), (0, 1000000000000000000000, 0), ((40, 8),)))
```
In addition to summoner information, crafted items can also be queried by address. 

See [rarity_structs](contracts/rarity_structs.sol) for an explanation of the data types.

## Interfaces 
> rarity_interfaces.sol
> 
> IERC721.sol

Includes the most relevant interfaces for all rarity core contracts, including ERC721.

## Structs
> rarity_structs.sol

Holds all the structs that are used in the library contract. 
Import this into your smart contract to have access to the library functionality.


# Tests
> [https://github.com/rarity-adventure/rarity-integration/tree/main/tests](https://github.com/rarity-adventure/rarity-integration/tree/main/tests).

