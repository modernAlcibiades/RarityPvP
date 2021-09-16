const { expect } = require("chai");
const { ethers } = require("hardhat");

// Load account
let deployer;
let rarity, rarity_attributes, rng;
let m, a, c, seed;

describe("Random Generator functions", function () {
  it("Deploy and test LCG contract", async function () {
    if (network.name == 'hardhat') {
      await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [process.env.ADDRESS],
      });
      deployer = await ethers.getSigner(process.env.ADDRESS)
    } else if (network.name == 'fantom') {
      deployer = (await ethers.getSigners())[0];
    }
    m = 2 ** 16 + 1;
    a = 75;
    c = 74;
    seed = 0;

    const RNG = await ethers.getContractFactory("lcgRandomGenerator");
    rng = await RNG.connect(deployer).deploy(m, a, c, seed);
    await rng.deployed();

    console.log("Deployed at", rng.address);
    console.log("Owner", await rng.owner());
    expect(await rng.owner()).to.equal(deployer.address);

    let local_x = 0;
    // Check random numbers
    for (let i = 0; i < 10; i++) {
      const txn = await rng.next();
      const receipt = await txn.wait();
      //console.log(txn);
      //console.log(parseInt(txn.value));
      // TODO : How to access return value of a write function

      // after update
      const x = parseInt(await rng.x());
      local_x = (a * local_x + c) % m;
      expect(x).to.equal(local_x);
    }
  });
});
