// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
pragma solidity ^0.8.1;

contract Graph {

    event deposit(address indexed user, uint256 amount);
    event withdraw(address indexed user, uint256 amount);
    
  struct UserInfo {
        uint256 amount;
        uint lastdeposittime;
        uint  lockedUntil;
        }
    
    uint public TotalbalanceReceived;
    uint public balancenow;

    mapping (IERC20 => mapping(address => UserInfo)) userInfo;

    function Deposit() public payable {
        UserInfo storage user = userInfo[IERC20 (0x0000000000000000000000000000000000001010)][msg.sender];
        balancenow += msg.value;
        user.amount += msg.value;
        TotalbalanceReceived += msg.value;
        user.lastdeposittime = block.timestamp;
        user.lockedUntil = block.timestamp + 60 minutes; 
        emit deposit(msg.sender, msg.value);
    }
    
    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }
    function getUserBalance(IERC20 token) public view returns (uint) {
    UserInfo storage user = userInfo[IERC20 (token)][msg.sender];
    return user.amount;
    }
    function Withdraw() public {
    UserInfo storage user = userInfo[IERC20 (0x0000000000000000000000000000000000001010)][msg.sender];

     if(user.lockedUntil < block.timestamp)
        {
        address payable to = payable(msg.sender);
        balancenow -= getUserBalance(IERC20 (0x0000000000000000000000000000000000001010));
        to.transfer(getUserBalance(IERC20 (0x0000000000000000000000000000000000001010)));
        user.amount -= getUserBalance(IERC20 (0x0000000000000000000000000000000000001010));
        emit withdraw(msg.sender, user.amount);
        }
    }

    function DepositERC20(IERC20 token, uint256 amount) public {
    UserInfo storage user = userInfo[IERC20 (token)][msg.sender];
        uint256 erc20balance = token.balanceOf(address(msg.sender));
        require(amount <= erc20balance, "balance is low");
        token.transfer(address(this), amount);
        user.amount +=amount;
        user.lastdeposittime = block.timestamp;
        user.lockedUntil = block.timestamp + 60 minutes; 
    }

    function WithdrawERC20(IERC20 token, uint256 amount) public {
    UserInfo storage user = userInfo[IERC20 (token)][msg.sender];
     if(user.lockedUntil < block.timestamp){
        require(amount <= user.amount, "balance is low");
        user.amount -= getUserBalance(IERC20 (token));
        token.transfer(msg.sender, amount);
     }
        
    }    
}   
