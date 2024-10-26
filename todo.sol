// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JustDo {
    struct ToDoItem {
        string task;
        bool isCompleted;
        address creator;
        mapping(address => bool) approvedUsers; 
    }

    mapping (uint256 => ToDoItem) public list;
    uint256 public count = 0;
    event TaskAdded(uint256 indexed id, address indexed creator);
    event TaskCompleted(uint256 indexed id, address indexed completer);
    event UserApproved(uint256 indexed id, address indexed user);
    event UserDisapproved(uint256 indexed id, address indexed user);

    function addTask(string calldata task) public {
        ToDoItem storage item = list[count];
        item.task = task;
        item.isCompleted = false;
        item.creator = msg.sender;
        item.approvedUsers[msg.sender] = true; 

        emit TaskAdded(count, msg.sender);
        count++;
    }

    function completeTask(uint256 id) public {
        require(id < count, "Invalid Task Id");
        require(!list[id].isCompleted, "Task already completed");
        require(list[id].approvedUsers[msg.sender], "You are not authorized to complete this task");

        list[id].isCompleted = true;
        emit TaskCompleted(id, msg.sender);
    }

    function approveUser(uint256 id, address user) public {
        require(id < count, "Invalid Task Id");
        require(list[id].creator == msg.sender, "Only the creator can approve users");
        
        list[id].approvedUsers[user] = true;
        emit UserApproved(id, user);
    }

    function disapproveUser(uint256 id, address user) public {
        require(id < count, "Invalid Task Id");
        require(list[id].creator == msg.sender, "Only the creator can disapprove users");

        list[id].approvedUsers[user] = false;
        emit UserDisapproved(id, user);
    }
}
