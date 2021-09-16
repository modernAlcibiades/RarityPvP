const { expect } = require("chai");
const { ethers } = require("hardhat");

let deployer;
let rarity, rarity_attributes, arena;
let tokens = [
  2371608, 2371609,
  2383706, 2383707,]

describe("Arena", function () {
  it("Deploy and test arena contract", async function () {
    if (network.name == 'hardhat') {
      await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [process.env.ADDRESS],
      });
      deployer = await ethers.getSigner(process.env.ADDRESS)
    } else if (network.name == 'fantom') {
      deployer = (await ethers.getSigners())[0];
    }

    const Arena = await ethers.getContractFactory("pvp_arena");
    arena = await Arena.connect(deployer).deploy();
    await arena.deployed();

    console.log("Deployed at", arena.address);
    console.log("Owner", await arena.owner());
    expect(await arena.owner()).to.equal(deployer.address);

    //Create match
    const bet = ethers.utils.parseEther('1.0');
    const numPlayers = 3
    const txn = await arena.newMatch(bet, numPlayers, { value: ethers.utils.parseEther('0.1') });
    const receipt = await txn.wait();
    console.log(receipt.events);

    // Join match with all the tokens
    for (let i = 0; i < numPlayers; i++) {
      const txn1 = await arena.joinMatch(0, tokens[i], { value: bet });
      const events = (await txn1.wait()).events;
      console.log(events);
    }
    await expect(arena.joinMatch(0, tokens[numPlayers], { value: bet }))
      .to.be.revertedWith('Match is already over');
  });
});