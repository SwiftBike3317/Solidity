var WaveToken = artifacts.require("WaveToken");
var MasterChef = artifacts.require("MasterChef");
module.exports = function(deployer) {
    deployer.deploy(WaveToken)
    deployer.deploy(MasterChef, "0x4259daA748B850e6fa69b66e3cF4240Af4faB86c", "0x7443e7E099a969ca075AE6d0e6411fe9a1A4D18B", "0x7443e7E099a969ca075AE6d0e6411fe9a1A4D18B", 10000, 11241000);
};
