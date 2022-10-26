const HDWalletProvider = require("@truffle/hdwallet-provider");
const fs = require("fs");
const privateKey = fs.readFileSync(".secret").toString().trim();

module.exports = {
    compilers: {
        solc: {
            version: "0.8.0",
            parser: "solcjs", // Leverages solc-js purely for speedy parsing
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200, // Optimize for how many times you intend to run the code
                },
                evmVersion: "istanbul", // Default: "istanbul"
            },
        },
    },
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*", // Match any network id
        },
        // polygon: {
        //     provider: new HDWalletProvider(mnemonic, process.env.POLYGON_RPC),
        //     network_id: 137,
        //     confirmations: 2,
        //     timeoutBlocks: 200,
        //     skipDryRun: true,
        // },
        mumbai: {
            provider: () =>
                new HDWalletProvider({
                    privateKeys: [privateKey],
                    providerOrUrl: `https://matic-mumbai.chainstacklabs.com`,
                    chainId: 80001,
                }),
            network_id: 80001,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true,
            chainId: 80001,
        },
    },
};
