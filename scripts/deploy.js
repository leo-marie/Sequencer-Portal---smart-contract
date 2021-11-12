/*
npx hardhat node
npx hardhat run scripts/deploy.js --network localhost
npx hardhat run scripts/deploy.js --network rinkeby
*/

const main = async () => {
  const sequencerContractFactory = await hre.ethers.getContractFactory('SequencerPortal');
  const sequencerContract = await sequencerContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.001'), // fund contract
  });

  await sequencerContract.deployed();

  console.log('SequencerPortal address: ', sequencerContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();