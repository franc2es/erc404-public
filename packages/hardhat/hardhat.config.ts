import * as dotenv from "dotenv";
dotenv.config();
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-chai-matchers";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "@nomicfoundation/hardhat-verify";
import "hardhat-deploy";
import "hardhat-deploy-ethers";

// If not set, it uses ours Alchemy's default API key.
// You can get your own at https://dashboard.alchemyapi.io
const providerApiKey = process.env.ALCHEMY_API_KEY || "oKxs-03sij-U_N0iOlrSsZFr29-IqbuF";
// If not set, it uses ours Etherscan default API key.
const etherscanApiKey = process.env.ETHERSCAN_API_KEY || "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW";

const mnemonic = process.env.MNEMONIC || "test test test test test test test test test test test junk"
const accounts = {
  mnemonic,
  path: "m/44'/60'/0'/0",
  initialIndex: 0,
  count: 20,
  passphrase: "",
};

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        // https://docs.soliditylang.org/en/latest/using-the-compiler.html#optimizer-options
        runs: 200,
      },
    },
  },
  defaultNetwork: "localhost",
  namedAccounts: {
    deployer: {
      // By default, it will take the first Hardhat account as the deployer
      default: 0,
    },
  },
  networks: {
    // View the networks that are pre-configured.
    // If the network you are looking for is not here you can add new network settings
    hardhat: {
      forking: {
        url: `https://eth-mainnet.alchemyapi.io/v2/${providerApiKey}`,
        enabled: process.env.MAINNET_FORKING_ENABLED === "true",
      },
    },
    mainnet: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${providerApiKey}`,
      accounts,
    },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    arbitrum: {
      url: `https://arb-mainnet.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    arbitrumSepolia: {
      url: `https://arb-sepolia.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    optimism: {
      url: `https://opt-mainnet.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    optimismSepolia: {
      url: `https://opt-sepolia.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    polygon: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    polygonMumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    polygonZkEvm: {
      url: `https://polygonzkevm-mainnet.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    polygonZkEvmTestnet: {
      url: `https://polygonzkevm-testnet.g.alchemy.com/v2/${providerApiKey}`,
      accounts,
    },
    gnosis: {
      url: "https://rpc.gnosischain.com",
      accounts,
    },
    chiado: {
      url: "https://rpc.chiadochain.net",
      accounts,
    },
    base: {
      url: "https://mainnet.base.org",
      accounts,
    },
    baseSepolia: {
      url: "https://sepolia.base.org",
      accounts,
    },
    scrollSepolia: {
      url: "https://sepolia-rpc.scroll.io",
      accounts,
    },
    scroll: {
      url: "https://rpc.scroll.io",
      accounts,
    },
    pgn: {
      url: "https://rpc.publicgoods.network",
      accounts,
    },
    pgnTestnet: {
      url: "https://sepolia.publicgoods.network",
      accounts,
    },
  },
  // configuration for harhdat-verify plugin
  etherscan: {
    apiKey: `${etherscanApiKey}`,
  },
  // configuration for etherscan-verify from hardhat-deploy plugin
  verify: {
    etherscan: {
      apiKey: `${etherscanApiKey}`,
    },
  },
  sourcify: {
    enabled: false,
  },
};

export default config;
