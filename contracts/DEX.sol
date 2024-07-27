// contracts/DEX.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEX {
    IERC20 public token;
    uint256 public rate = 100;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function buyTokens() public payable {
        uint256 tokenAmount = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokenAmount, "DEX: Insufficient token balance");
        token.transfer(msg.sender, tokenAmount);
    }

    function sellTokens(uint256 _amount) public {
        require(token.balanceOf(msg.sender) >= _amount, "DEX: Insufficient token balance");
        uint256 etherAmount = _amount / rate;
        require(address(this).balance >= etherAmount, "DEX: Insufficient ether balance");
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(etherAmount);
    }
}
