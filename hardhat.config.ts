import '@nomiclabs/hardhat-solpp';
import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-etherscan';
import '@typechain/hardhat';

const config = {
    CHAIN_ID: process.env.CHAIN_ETH_ZKSYNC_NETWORK_ID,
    L1_SHARED_BRIDGE_PROXY_ADDR: process.env.CONTRACTS_L1_SHARED_BRIDGE_PROXY_ADDR
};

export default {
    solidity: {
        version: '0.8.18',
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            },
            outputSelection: {
                '*': {
                    '*': ['storageLayout']
                }
            }
        }
    },
    contractSizer: {
        runOnCompile: false
    },
    paths: {
        sources: './contracts'
    },
    solpp: {
        defs: config
    },
    etherscan: {
        apiKey: process.env.MISC_ETHERSCAN_API_KEY
    }
};
