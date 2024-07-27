// test/DEX.test.js
const { expect } = require("chai");

describe("DEX", function () {
    let Token, token, DEX, dex, owner, addr1;

    beforeEach(async function () {
        Token = await ethers.getContractFactory("Token");
        token = await Token.deploy("MyToken", "MTK", ethers.utils.parseEther("1000"));
        await token.deployed();

        DEX = await ethers.getContractFactory("DEX");
        dex = await DEX.deploy(token.address);
        await dex.deployed();

        [owner, addr1] = await ethers.getSigners();
        await token.transfer(dex.address, ethers.utils.parseEther("100"));
    });

    it("Should allow users to buy tokens", async function () {
        await dex.connect(addr1).buyTokens({ value: ethers.utils.parseEther("1") });
        expect(await token.balanceOf(addr1.address)).to.equal(ethers.utils.parseEther("100"));
    });

    it("Should allow users to sell tokens", async function () {
        await dex.connect(addr1).buyTokens({ value: ethers.utils.parseEther("1") });
        await token.connect(addr1).approve(dex.address, ethers.utils.parseEther("100"));
        await dex.connect(addr1).sellTokens(ethers.utils.parseEther("100"));
        expect(await token.balanceOf(addr1.address)).to.equal(0);
    });
});
