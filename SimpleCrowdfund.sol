// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract SimpleCrowdfund{

    uint256 public amountRaised = 0;
    bool public campaignEnded;
    bool public goalReached;
    bool public fundsWithdrawned;

    uint256 constant public GOAL = 2e18;  //2 eth in wei
    uint256 constant public minimalAmount = 1e15;  // ~3$

    address immutable i_owner = payable(msg.sender);
    uint256 immutable i_timeInitiation = block.timestamp; // Setting up initiation time
    uint256 immutable public i_secToComplete = 30;//3600 * 24;
    uint256 immutable public i_deadline = i_timeInitiation + i_secToComplete; // final time to complete the task

    address[] public ContributorsList;

    event Contributed(address contributor, uint256 amount);
    event Withdraw(address owner, uint256 amount);    
    event Refunded(address contributor, uint256 amount);
    //event Raised(uint256 amountRaised, uint256 GOAL);

    mapping (address contributor => uint256 amountDonated) public ContributorToAmount;
    mapping (address contributor => bool isContributor) public AlreadyContributed;

    error NotTheOwner();
    error ZeroAddress();
    error ToLittleDonation();
    error CampaignIsNotEnded();
    error CampaignIsEnded();
    error CallFailed();
    
    
    modifier onlyOwner{
        if(msg.sender != i_owner) {revert NotTheOwner();}
        _;
    }

    modifier isWithdrawned{ // test that modifier
        if(fundsWithdrawned) {revert CallFailed();}
        _;
    }

    constructor(address _owner, uint256 _secToComplete){
        if (_owner == address(0)){
            revert ZeroAddress();
        }
        i_owner = _owner;
        i_timeInitiation = block.timestamp;
        i_deadline = i_timeInitiation + _secToComplete;
    }

    function contribute() payable public{
        // Check: If a user calls contribute() after the deadline, the call should revert or fail.
        // The contract should keep track of the total amount raised. Check: Every time function is envoke, check if goal is reached 
        
        if(msg.value < minimalAmount){revert ToLittleDonation();}
        if(amountRaised >= GOAL){revert CampaignIsEnded();}
        if(timePassed()){revert CampaignIsEnded();}
        
        if(AlreadyContributed[msg.sender] == false){
            ContributorsList.push(msg.sender);
            ContributorToAmount[msg.sender] = ContributorToAmount[msg.sender] + msg.value;
            AlreadyContributed[msg.sender] = true;
            amountRaised = amountRaised + msg.value;
            emit Contributed(msg.sender, msg.value);
        }
        
        else 
        {
            ContributorToAmount[msg.sender] = ContributorToAmount[msg.sender] + msg.value;
            amountRaised = amountRaised + msg.value;
            emit Contributed(msg.sender, msg.value);
        }
    }

    function withdraw() public onlyOwner isWithdrawned{
        // DONE check: only the Project Owner should be able to withdraw the entire balance. 
        // DONE check: If the goal is reached on or before the deadline, only the Project Owner should be able to withdraw the entire balance. 
        // DONE check: If the owner tries to call withdraw() before the deadline but the goal isn’t reached yet, it should fail.
        // DONE check: If the user calling withdraw() is not the Project Owner, it should fail.
        // check: After withdraw user should not be able to contribute more 
        if(amountRaised >= GOAL){
            
            (bool callSuccess, ) = payable(i_owner).call{value: address(this).balance}("");
            if(!callSuccess){revert CallFailed();}
            else{emit Withdraw(i_owner, amountRaised);}
            fundsWithdrawned = true;
            }
    }

    function refund() public{
        // check: If the goal is not reached by the time the deadline passes, backers should be able to get their ETH back by calling refund()
        // check:  If the goal is reached or if we are still before the deadline, calling refund() should fail.
        if(timePassed() && amountRaised < GOAL)
        {
            for(uint256 ContributorIndex = 0; ContributorIndex < ContributorsList.length; ContributorIndex++){
                (bool callSuccess, ) = payable(ContributorsList[ContributorIndex]).call{value: address(this).balance}("");
                if(!callSuccess){revert CallFailed();}
                else{emit Withdraw(i_owner, amountRaised);}
            }
        }
    }

    function timePassed() internal view returns (bool isEnded){  // CHANGE visibility
        uint256 currentTimestamp = block.timestamp;
        if (currentTimestamp > i_timeInitiation + i_secToComplete){
            return true;
        }
    }

    // function isContributor(address _address) public returns (bool included){
    // }

    receive() external payable{
        contribute();
    }
    fallback() external payable{
        contribute();
    }
}
// Trash

        // if(amountRaised < GOAL){
        //     emit Raised(amountRaised, GOAL);}
        
        // else {revert CampaignIsEnded();}
        //     _;
        // }