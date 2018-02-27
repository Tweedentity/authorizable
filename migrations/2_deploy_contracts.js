var Authorizable = artifacts.require("./Authorizable")

module.exports = function(deployer) {
  deployer.deploy(Authorizable)
}
