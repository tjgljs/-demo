require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    goerli: {
      url: `http://127.0.0.1:7545`,
      accounts: ['0xbe249b2e1c7e9068c305f378f46393c5ac759adee2822b1f53070f89806913ef']
    }
  },
};
