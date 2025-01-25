// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract SimpleCrowdfund{

    uint256 public goal;
    uint256 public deadline;
    uint256 public amountRaised;
    uint256 public contributors;
    
    event Contributed(address contributor, uint256 amount);
    event Withdraw(address owner, uint256 amount);    
    event Refunded(address contributor, uint256 amount);

    mapping (address backer => uint256 amountDonated) internal BackerToAmount;

    error notTheOwner();
    error ZeroAddress();

    address immutable i_owner = msg.sender;
    constructor(address _owner){
        if (_owner == address(0)){
            revert ZeroAddress();
        }
        i_owner = _owner;
    }

    function contribute() payable public{
        // Check: If a user calls contribute() after the deadline, the call should revert or fail.
        // The contract should keep track of the total amount raised. Check: Every time function is envoke, check if goal is reached 

    }

    function withdraw() public{
        // check: only the Project Owner should be able to withdraw the entire balance. 
        // check: If the goal is reached on or before the deadline, only the Project Owner should be able to withdraw the entire balance. 
        // check: If the user tries to call withdraw() before the deadline but the goal isn’t reached yet, it should fail.
        // check: If the user calling withdraw() is not the Project Owner, it should fail.

    }

    function refund() public{
        // check: If the goal is not reached by the time the deadline passes, backers should be able to get their ETH back by calling refund()
        // check:  If the goal is reached or if we are still before the deadline, calling refund() should fail.
        
    }

}