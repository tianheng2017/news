const NewsContract = artifacts.require("NewsContract");

module.exports = async function (deployer) {
    deployer.deploy(NewsContract);
}