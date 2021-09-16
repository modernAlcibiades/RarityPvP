const { expect } = require("chai");
const { ethers } = require("hardhat");

let deployer;
let rarity, rarity_attributes, arena;

describe("Arena", function () {
  it("Deploy and test arena contract", async function () {
    // Load account
    let deployer;
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
    const arena = await Arena.connect(deployer).deploy();
    await arena.deployed();

    console.log("Deployed at", arena.address);
    console.log("Owner", await arena.owner());
    expect(await arena.owner()).to.equal(deployer.address);
  });
});