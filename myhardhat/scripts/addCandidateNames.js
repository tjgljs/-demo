const hre = require("hardhat");

async function main() {
    // 合约部署后的地址
    const contractAddress = "0x76C2481F85410912dF3D8A419dA3Da757E81984e";

    // 获取合约实例
    const VotingContract = await hre.ethers.getContractAt("VotingContract", contractAddress);

    // 要添加的候选人名字数组
    const candidateNames = ["Alice", "Bob", "Charlie"];

    // 调用合约的 addCandidateNames 方法
    const transactionResponse = await VotingContract.addCandidateNames(candidateNames);
    await transactionResponse.wait();

    console.log("Candidates added successfully!");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    }); 