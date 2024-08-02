const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const Token = await hre.ethers.getContractFactory("Token");
  const token1 = await Token.deploy(1000000);
  const token2 = await Token.deploy(1000000);

  await token1.deployed();
  await token2.deployed();

  console.log("Token1 deployed to:", token1.address);
  console.log("Token2 deployed to:", token2.address);

  const AdvancedDEX = await hre.ethers.getContractFactory("myDEX");
  const dex = await AdvancedDEX.deploy(token1.address, token2.address);

  await dex.deployed();
  console.log("myDEX deployed to:", dex.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
