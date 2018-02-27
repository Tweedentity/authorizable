const HDWalletProvider = require("truffle-hdwallet-provider")
const mnemonic = process.env.MNEMONIC
const infuraUrl = process.env.INFURA_URL

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*"
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, infuraUrl)
      },
      network_id: 3
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
