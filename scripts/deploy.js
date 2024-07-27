// scripts/deploy.js
async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy("MyToken", "MTK", ethers.utils.parseEther("1000"));
    await token.deployed();
    console.log("Token deployed to:", token.address);

    const DEX = await ethers.getContractFactory("DEX");
    const dex = await DEX.deploy(token.address);
    await dex.deployed();
    console.log("DEX deployed to:", dex.address);

    // Transfer some tokens to DEX contract
    await token.transfer(dex.address, ethers.utils.parseEther("100"));
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
