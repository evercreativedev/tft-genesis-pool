var pool = artifacts.require("GenesisPool");

const RINKBY_ERC1155 = "0xDE7298afb98885D68Be70927Dbb5057E5542E201";
const RINKBY_ERC20 = "0x70973CA69a81b96231C7475D559014c739bA2cf6";

module.exports = function(developer, network, accounts) {
  developer.deploy(pool, RINKBY_ERC1155, RINKBY_ERC20);
};
