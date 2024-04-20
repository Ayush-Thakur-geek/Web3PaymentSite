require("@nomicfoundation/hardhat-toolbox")
require("dotenv").config()
require("@nomicfoundation/hardhat-verify")
require("./tasks/block-number")
require("hardhat-gas-reporter")
require("solidity-coverage")

/** @type import('hardhat/config').HardhatUserConfig */

const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL || "http://localhost:8545"
const PRIVATE_KEY = process.env.PRIVATE_KEY || "0xkey"
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "key"
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "key"

module.exports = {
    solidity: "0.8.24",
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {},
        sepolia: {
            url: SEPOLIA_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 11155111,
        },
    },
    localhost: {
        url: "http://127.0.0.1:8545/",
        chainId: 31337,
    },

    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
    sourcify: {
        // Disabled by default
        // Doesn't need an API key
        enabled: true,
    },

    gasReporter: {
        enabled: true,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        gasPrice: 100,
        coinmarketcap: COINMARKETCAP_API_KEY,
        // excludeContracts: ["contracts/mocks/", "contracts/interfaces/"],
        token: "MATIC",
    },
}
