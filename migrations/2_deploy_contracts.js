var BaseToken = artifacts.require("BaseToken");
var SimpleLoan = artifacts.require("SimpleLoan");

module.exports = function(deployer) {

    return deployer.deploy(BaseToken, 10000, 'Ya', 3, 'sx');
};
