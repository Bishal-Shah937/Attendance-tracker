// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceVerification {

    address public owner;
    uint256 public rewardAmount;
    mapping(address => uint256) public attendanceRecords;
    mapping(address => bool) public hasClaimedReward;

    event AttendanceMarked(address indexed student);
    event RewardClaimed(address indexed student, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(uint256 _rewardAmount) {
        owner = msg.sender;
        rewardAmount = _rewardAmount;
    }

    
    function markAttendance(address student) external onlyOwner {
        attendanceRecords[student]++;
        emit AttendanceMarked(student);
    }

    
    function claimReward() external {
        require(attendanceRecords[msg.sender] > 0, "No attendance recorded");
        require(!hasClaimedReward[msg.sender], "Reward already claimed");

        uint256 reward = attendanceRecords[msg.sender] * rewardAmount;
        hasClaimedReward[msg.sender] = true;

        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
    }

    
    function setRewardAmount(uint256 _rewardAmount) external onlyOwner {
        rewardAmount = _rewardAmount;
    }

    
    receive() external payable {}

    // Function to withdraw contract balance (for owner)
    function withdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner).transfer(amount);
    }
}
