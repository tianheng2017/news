module.exports = {
    contracts_build_directory: './client/src/contracts',
    contracts_directory: './contracts',
    networks: {
        develop: {
            host: "127.0.0.1",
            port: 8545,
            network_id: 1337,
        },
    },
    compilers: {
        solc: {
            version: "0.8.0",
        }
    }
};
