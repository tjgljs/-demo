// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {

 // 候选人结构体
    struct Candidate {
        string name;   // 候选人名称
        uint256 voteCount; // 候选人票数
    }   

    // 候选人列表
    Candidate[] public candidates;

    // 投票者地址映射，用于记录投票者是否已经投票
    mapping(address => bool) public hasVoted;

    //新增 每个人最多可以给几个人投票
    uint256 public maxNum;

    // 合约所有者
    address public owner;

    // 事件定义
    event CandidateAdded(string name);
    event Voted(address voter, uint256 candidateIndex);
    event OwnershipTransferred(address previousOwner, address newOwner);
    event SetMaxNum(uint256 indexed newMaxNum);

    // 构造函数
    //新增每个用户最多可以给几个人投票
    constructor(uint256 _maxNum) {
        owner = msg.sender;
        maxNum=_maxNum;
    }
     // 只允许合约所有者执行的修饰符
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    //新增管理员可以修改每个用户最多可以给几个人投票
    function setMaxNum(uint256 _maxNum)external onlyOwner{
        maxNum=_maxNum;
        emit SetMaxNum(_maxNum);
    }

    //增加 
    //添加候选人
    function addCandidateNames(string[]memory _candidateNames)external  onlyOwner{
       for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({
                name: _candidateNames[i],
                voteCount: 0
            }));
            emit CandidateAdded(_candidateNames[i]);
        }
    }
   
    // 转移合约所有权
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    //修改每个人可以给多个候选人投票
    // 接受投票给候选人的索引 
    function vote(uint256[] memory _candidateIndexs) public {
        // 检查投票者是否已经投票
        require(!hasVoted[msg.sender], "You have already voted!");

        // 检查 _candidateIndexs 的长度是否超过最大投票个数
        require(_candidateIndexs.length <= maxNum, "Invalid candidates num");

        // 创建一个新的数组来跟踪已处理的候选人索引
        bool[] memory seen = new bool[](candidates.length);

        for (uint256 i = 0; i < _candidateIndexs.length; i++) {
            require(_candidateIndexs[i] < candidates.length, "Invalid candidate index!");

            // 检查候选人是否已经投票
            require(!seen[_candidateIndexs[i]], "Duplicate candidate index found!");

            // 将当前候选人索引标记为已处理
            seen[_candidateIndexs[i]] = true;

            // 实现投票 --> 给候选人票数累加
            candidates[_candidateIndexs[i]].voteCount++;
            emit Voted(msg.sender, _candidateIndexs[i]);
        }

        // 将投票人的状态改为已投票
        hasVoted[msg.sender] = true;
}

    //修改 不仅返回票数，也会返回候选人名字
    // 接受候选人的索引
    function getVoteCount(uint256 _candidateIndex) public view returns (string memory,uint256) {
        // 判断传递的索引是否有误
        require(
            _candidateIndex < candidates.length,
            "Invalid candidate index."
        );
        // 返回对应候选人的票数
        return (candidates[_candidateIndex].name,candidates[_candidateIndex].voteCount);
    }
    //修改根据票数进行排序 从大到小
    // 将候选人列表返回
    function getAllCandidates() public view returns (Candidate[] memory) {
         // 创建一个新的数组用于排序
        Candidate[] memory sortedCandidates = new Candidate[](candidates.length);

        // 将原数组的内容复制到新的数组
        for (uint256 i = 0; i < candidates.length; i++) {
            sortedCandidates[i] = candidates[i];
        }

        // 简单的选择排序算法，从大到小排序
        for (uint256 i = 0; i < sortedCandidates.length; i++) {
            for (uint256 j = i + 1; j < sortedCandidates.length; j++) {
                if (sortedCandidates[i].voteCount < sortedCandidates[j].voteCount) {
                    Candidate memory temp = sortedCandidates[i];
                    sortedCandidates[i] = sortedCandidates[j];
                    sortedCandidates[j] = temp;
                }
            }
        }

        return sortedCandidates;
    }
    

    // 添加新候选人（只有合约所有者可以调用）
    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({
            name: _name,
            voteCount: 0 // 初始化为空的字符串数组
        }));
        emit CandidateAdded(_name);
    }
}