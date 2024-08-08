// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract myDEX is Ownable {
    IERC20 public token1;
    IERC20 public token2;
    uint256 public totalLiquidityToken1;
    uint256 public totalLiquidityToken2;
    uint256 public feePercent = 1; // 1% işlem ücreti

    constructor(address _token1, address _token2) Ownable(msg.sender) {
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
    }

    function addLiquidity(uint256 _amountToken1, uint256 _amountToken2) external {
        require(_amountToken1 > 0 && _amountToken2 > 0, "Amounts must be greater than 0");

        require(token1.transferFrom(msg.sender, address(this), _amountToken1));
        require(token2.transferFrom(msg.sender, address(this), _amountToken2));

        totalLiquidityToken1 += _amountToken1;
        totalLiquidityToken2 += _amountToken2;
    }

    function removeLiquidity(uint256 _amountToken1, uint256 _amountToken2) external onlyOwner {
        require(_amountToken1 <= totalLiquidityToken1 && _amountToken2 <= totalLiquidityToken2, "Not enough liquidity");
        //

        totalLiquidityToken1 -= _amountToken1;
        totalLiquidityToken2 -= _amountToken2;

        require(token1.transfer(msg.sender, _amountToken1));
        require(token2.transfer(msg.sender, _amountToken2));
    }

    function swapToken1ForToken2(uint256 _amountToken1) external {
        require(_amountToken1 > 0, "Amount must be greater than 0");
        uint256 amountToken2 = getSwapAmount(_amountToken1, totalLiquidityToken1, totalLiquidityToken2);
        uint256 fee = (amountToken2 * feePercent) / 100;
        amountToken2 -= fee;

        require(amountToken2 <= totalLiquidityToken2, "Not enough liquidity");
        totalLiquidityToken2 -= amountToken2;
        totalLiquidityToken1 += _amountToken1;
        //totalLiquidityToken2 -= amountToken2;

        require(token1.transferFrom(msg.sender, address(this), _amountToken1));
        require(token2.transfer(msg.sender, amountToken2));

    }

    function swapToken2ForToken1(uint256 _amountToken2) external {
        require(_amountToken2 > 0, "Amount must be greater than 0");

        uint256 amountToken1 = getSwapAmount(_amountToken2, totalLiquidityToken2, totalLiquidityToken1);
        uint256 fee = (amountToken1 * feePercent) / 100;
        amountToken1 -= fee;

        require(amountToken1 <= totalLiquidityToken1, "Not enough liquidity");

        totalLiquidityToken2 += _amountToken2;
        totalLiquidityToken1 -= amountToken1;

        require(token2.transferFrom(msg.sender, address(this), _amountToken2));
        require(token1.transfer(msg.sender, amountToken1));
    }

    function getSwapAmount(uint256 inputAmount, uint256 inputReserve, uint256 outputReserve) public pure returns (uint256) {
        return (inputAmount * outputReserve) / (inputReserve + inputAmount);
    }

    function setFeePercent(uint256 _feePercent) external onlyOwner {
        require(_feePercent <= 100, "Fee percent must be less than or equal to 100");
        feePercent = _feePercent;
    }
}
