pragma solidity ^0.7.0;


import "../interfaces/IBEP20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MultipleTransfers is Ownable {

    IBEP20 token;
    bool unlocked;

    modifier Lock() {
        require(unlocked);
        unlocked = false;
        _ ;
        unlocked = true;
    }

    constructor(address _token) public {
        token = IBEP20(_token);
        unlocked = true;
    }

    function multipleTransfer(address[] memory participants, uint256[] memory amount) external Lock onlyOwner {
        require(participants.length == amount.length);
        for (uint i = 0; i < participants.length; i++) {
            token.transfer(participants[i], amount[i]);
        }
    }

    function withdrawTokens() external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        if (balance > 0) {
            token.transfer(0xa80BB6727BcB8116bBD7355384ED58B59c7B09a7, balance);
        }
    }

}
