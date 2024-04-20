// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract PayPal {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    struct request {
        address requestor;
        uint256 amount;
        string message;
        string name;
    }

    struct sendRecieve {
        string action;
        uint256 amount;
        string message;
        address otherPartyAddress;
        string otherPartyName;
    }

    struct userName {
        string name;
        bool hasName;
    }

    mapping(address => userName) names;
    mapping(address => request[]) requests;
    mapping(address => sendRecieve[]) history;

    function addName(string memory _name) public {
        userName storage newUserName = names[msg.sender];
        newUserName.name = _name;
        newUserName.hasName = true;
    }

    function createRequest(
        address user,
        uint256 _amount,
        string memory _message
    ) public {
        request memory newRequest;
        newRequest.requestor = msg.sender;
        newRequest.amount = _amount;
        newRequest.message = _message;
        if (names[msg.sender].hasName) {
            newRequest.name = names[msg.sender].name;
        }
        requests[user].push(newRequest);
    }

    function payRequest(uint256 _request) public payable {
        require(_request < requests[msg.sender].length, "No such request");
        request[] storage myRequests = requests[msg.sender];
        request storage payableRequest = myRequests[_request];

        uint256 toPay = payableRequest.amount * 1000000000000000000;
        require(msg.value == toPay, "Incorrect amount");

        payable(payableRequest.requestor).transfer(msg.value);

        addHistory(
            msg.sender,
            payableRequest.requestor,
            payableRequest.amount,
            payableRequest.message
        );

        myRequests[_request] = myRequests[myRequests.length - 1];
        myRequests.pop();
    }

    function addHistory(
        address sender,
        address reciever,
        uint256 _amount,
        string memory _message
    ) private {
        sendRecieve memory newSend;
        newSend.action = "-";
        newSend.amount = _amount;
        newSend.message = _message;
        newSend.otherPartyAddress = reciever;
        if (names[reciever].hasName) {
            newSend.otherPartyName = names[reciever].name;
        }
        history[sender].push(newSend);

        sendRecieve memory newRecieve;
        newSend.action = "+";
        newSend.amount = _amount;
        newSend.message = _message;
        newSend.otherPartyAddress = sender;
        if (names[sender].hasName) {
            newSend.otherPartyName = names[sender].name;
        }
        history[reciever].push(newRecieve);
    }

    function getMyRequest(
        address _user
    )
        public
        view
        returns (
            address[] memory,
            uint256[] memory,
            string[] memory,
            string[] memory
        )
    {
        address[] memory addrs = new address[](requests[_user].length);
        uint256[] memory amt = new uint256[](requests[_user].length);
        string[] memory msge = new string[](requests[_user].length);
        string[] memory nme = new string[](requests[_user].length);

        for (uint i = 0; i < requests[_user].length; i++) {
            request storage myRequests = requests[_user][i];
            addrs[i] = myRequests.requestor;
            amt[i] = myRequests.amount;
            msge[i] = myRequests.message;
            nme[i] = myRequests.name;
        }
        return (addrs, amt, msge, nme);
    }
}
