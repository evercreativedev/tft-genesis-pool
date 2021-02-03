var pool = artifacts.require("GenesisPool");

const MAIN_ERC1155 = "0xDCb02DAcd87e66F6414fbF913A5b0e58f0dD5eA6";
const MAIN_ERC20 = "0x0cae187828a43c3a8dc5722c5c71ebd7c1ae2987"; // Must be UNIV2

module.exports = function(developer, network, accounts) {
  developer.deploy(pool, MAIN_ERC1155, MAIN_ERC20);
};
