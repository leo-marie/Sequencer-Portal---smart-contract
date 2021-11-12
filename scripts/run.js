/*
npx hardhat run scripts/run.js
1. Creating a new local Ethereum network.
2. Deploying your contract.
3. Then, when the script ends Hardhat will automatically destroy that local network.
*/


const main = async () => {
    const sequencerContractFactory = await hre.ethers.getContractFactory('SequencerPortal');
    const sequencerContract = await sequencerContractFactory.deploy({
      value: hre.ethers.utils.parseEther('0.1'), // fund the contract with my personal wallet
    });
    await sequencerContract.deployed();
    console.log('Contract addy:', sequencerContract.address);

    /*
    * Get Contract balance
    */
    let contractBalance = await hre.ethers.provider.getBalance(
      sequencerContract.address
    );
    console.log(
      'Contract balance:',
      hre.ethers.utils.formatEther(contractBalance)
    );

    /*
    * Send sequence
    */
    const saveSequenceTxn = await sequencerContract.saveSequence('sequence 1');
    await saveSequenceTxn.wait();
    /*
    const saveSequenceTxn2 = await sequencerContract.saveSequence('sequence 2');
    await saveSequenceTxn2.wait();
    const saveSequenceTxn3 = await sequencerContract.saveSequence('sequence 3');
    await saveSequenceTxn3.wait();
    const saveSequenceTxn4 = await sequencerContract.saveSequence('sequence 4');
    await saveSequenceTxn4.wait();
    */
    /*
    * Get Contract balance to see what happened!
    */
    contractBalance = await hre.ethers.provider.getBalance(sequencerContract.address);
    console.log(
      'Contract balance:',
      hre.ethers.utils.formatEther(contractBalance)
    );

    let allSequences = await sequencerContract.getAllSequences();
    console.log(allSequences);
  };

 const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();