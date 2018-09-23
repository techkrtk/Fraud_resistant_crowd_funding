pragma solidity ^0.4.17;

contract CampaignFactory{
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[]){
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {   //struct definition and key value pair's, to use it instance has to be created.
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping (address => bool ) approvals;
    }

    Request[] public requests; //array of instances of struct Request.
    address public manager; //anyone must be able to view manager
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint minimum, address creator) public {
        manager = creator; //sender means the person who is creating or deploying the contract
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true; //adds a new key of address and gives a value of true to it.
        approversCount++;
    }

    function createRequest(string description, uint value, address recipient) public restricted{
        Request memory  newRequest = Request({  //new instance of struct
            description: description,
            recipient: recipient, 
            value: value,  
            complete: false,
            approvalCount:0   //intialist struct requires only value types to be initialised not the reference types so we havent intiialised the approvals mapping.
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        
        Request storage request = requests[index];
        
        require(approvers[msg.sender]); //usage of mapping to check if the person has already donated to out contract
        require(!request.approvals[msg.sender]); //checks if the user already voted the given request.
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete); //making sure the request is not already cpmpleted
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns (
        uint, uint, uint, uint, address
    ) {
        return (
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint){
        return requests.length;
    }
}