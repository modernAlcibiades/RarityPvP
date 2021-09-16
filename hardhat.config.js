require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.7",
  networks: {
    hardhat: {
      forking: {
        chainId: 250,
        url: "https://rpc.ftm.tools/",
        blockNumber: 17115171,
      }
    },
    fantom: {
      chainId: 250,
      url: "https://rpc.ftm.tools/",
      accounts: [process.env.PRIVATE_KEY],
      maxFeePerGas: 190000000000
    },
  },
  "evmVersion": "berlin"
};
