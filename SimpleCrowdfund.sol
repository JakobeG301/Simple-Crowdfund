// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract SimpleCrowdfund{

    uint256 public amountRaised;
    uint256 public contributors;
    bool public campaignEnded;
    bool public goalReached;

    event Contributed(address contributor, uint256 amount);
    event Withdraw(address owner, uint256 amount);    
    event Refunded(address contributor, uint256 amount);
    event Raised(uint256 amountRaised, uint256 GOAL);

    mapping (address backer => uint256 amountDonated) internal BackerToAmount;

    error NotTheOwner();
    error ZeroAddress();
    error CampaignIsNotEnded();
    error CampaignIsEnded();
    
    address immutable i_owner = payable(msg.sender);
    uint256 immutable i_timeInitiation = block.timestamp; // Setting up initiation time
    uint256 constant public GOAL = 2e18;  //2 eth in wei
    uint256 immutable public secToComplete = 3600 * 24;
    uint256 immutable public deadline = i_timeInitiation + secToComplete; // Number of seconds to complete the task

    modifier onlyOwner{
        if(msg.sender != i_owner) {revert NotTheOwner();}
        _;
    }
    
    modifier TotalAmount{
        if(amountRaised < GOAL){
            emit Raised(amountRaised, GOAL);}
        
        else {revert CampaignIsEnded();}
            _;
        }

    constructor(address _owner){ //add how much houres owner has to complete the task
        if (_owner == address(0)){
            revert ZeroAddress();
        }
        i_owner = _owner;
    }

    function contribute(address contributor, uint256 amount) payable public{
        // Check: If a user calls contribute() after the deadline, the call should revert or fail.
        // The contract should keep track of the total amount raised. Check: Every time function is envoke, check if goal is reached 
        if(campaignEnded == true){
            revert CampaignIsEnded();
        }




        emit Contributed(contributor, amount);
    }

    function withdraw() public onlyOwner{
        // check: only the Project Owner should be able to withdraw the entire balance. 
        // check: If the goal is reached on or before the deadline, only the Project Owner should be able to withdraw the entire balance. 
        // check: If the user tries to call withdraw() before the deadline but the goal isn’t reached yet, it should fail.
        // check: If the user calling withdraw() is not the Project Owner, it should fail.

    }

    function refund() public{
        // check: If the goal is not reached by the time the deadline passes, backers should be able to get their ETH back by calling refund()
        // check:  If the goal is reached or if we are still before the deadline, calling refund() should fail.
        
    }

    function timePassed(uint256 _passedTime) internal view returns (bool isEnded){  // CHANGE visibility
        uint256 currentTimestamp = block.timestamp;
        if (currentTimestamp <= i_timeInitiation + _passedTime){
            return true;
        }

    }
    receive() external payable{
        contribute(msg.sender, msg.value);
    }
    fallback() external payable{
        contribute(msg.sender, msg.value);
    }
}