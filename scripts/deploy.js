const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const Token = await hre.ethers.getContractFactory("Token");
  const token = await Token.deploy(1000000);

  await token.deployed();
  console.log("Token deployed to:", token.address);

  const DEX = await hre.ethers.getContractFactory("DEX");
  const dex = await DEX.deploy(token.address);

  await dex.deployed();
  console.log("DEX deployed to:", dex.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
