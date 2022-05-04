const hre = require("hardhat");

async function main() {
  const MarketPlace = await hre.ethers.getContractFactory("MarketPlace");
  const marketplace = await MarketPlace.deploy(2);

  await marketplace.deployed();

  console.log("MarketPlace contract deployed to:", marketplace.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
