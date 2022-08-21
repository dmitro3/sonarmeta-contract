// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Storage.sol";
import "./Events.sol";
import "./ReentrancyGuard.sol";
import "./Config.sol";

/// @title SonarMeta main contract
/// @author SonarX Team
contract SonarMeta is Storage, Events, ReentrancyGuard, Context, Config {

    constructor(address _tokenAddress) {
        initializeReentrancyGuard();

        ERC20Token = Token(_tokenAddress);
    }

    function applyForAirdrop() external nonReentrant {
        require(appliedAirdropWhitelist[_msgSender()] == false, "haa");
        ERC20Token.airdrop(_msgSender(), AIRDROP_AMOUNT);
        appliedAirdropWhitelist[_msgSender()] = true;
    }

    function getERC20Balance(address _owner) external returns (uint256) {
        require(_owner != address(0), "oi0");
        return ERC20Token.balanceOf(_owner);
    }

    function approveERC20ToContract(uint256 _amount) external nonReentrant {
        require(_amount != 0, "ai0");
        require(ERC20Token.approve(address(this), _amount), "af");
    }

    function transferERC20(address _to, uint256 _amount) external nonReentrant {
        require(_amount != 0, "ai0");
        require(_to != address(0), "ti0");
        require(ERC20Token.transfer(_to, _amount), "tf");
    }

    function transferERC20UsingContractAllowance(address _to, uint256 _amount) external nonReentrant {
        require(_amount != 0, "ai0");
        require(_to != address(0), "ti0");
        require(ERC20Token.transferFrom(address(this), _to, _amount), "tf");
    }

}