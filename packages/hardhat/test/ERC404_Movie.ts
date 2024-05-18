import { expect } from "chai";
import { ethers } from "hardhat";
import { ERC404_Movie } from "../typechain-types";

describe("ERC404_Movie", function () {
  // We define a fixture to reuse the same setup in every test.

  let ERC404_Movie: ERC404_Movie;
  before(async () => {
    const [owner] = await ethers.getSigners();
    const ERC404_MovieFactory = await ethers.getContractFactory("ERC404_Movie");
    ERC404_Movie = (await ERC404_MovieFactory.deploy()) as ERC404_Movie;
    await ERC404_Movie.waitForDeployment();
  });

  // describe("Deployment", function () {
  //   it("Should have the right message on deploy", async function () {
  //     expect(await ERC404_Movie.greeting()).to.equal("Building Unstoppable Apps!!!");
  //   });

  //   it("Should allow setting a new message", async function () {
  //     const newGreeting = "Learn Scaffold-ETH 2! :)";

  //     await ERC404_Movie.setGreeting(newGreeting);
  //     expect(await ERC404_Movie.greeting()).to.equal(newGreeting);
  //   });
  // });

  describe("tmp", function () {
    it("buySBT", async function () {
      const sbtPrice = 10 ** 15;
      const ftPrice = 10 ** 15;
      const ftSwapAmount = 10000;
      await ERC404_Movie.launch("First Movie", sbtPrice, ftPrice, ftSwapAmount);

      const tokenId = 0;
      await ERC404_Movie.buySBT(tokenId, { value: sbtPrice });
      const [owner] = await ethers.getSigners();
      expect(await ERC404_Movie.sbtStatus(tokenId, owner)).to.equal(1);
    });
  });
});
