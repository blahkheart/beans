// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@opengsn/contracts/src/ERC2771Recipient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EcoWallet is ERC2771Recipient {
    IERC20 public token;

    constructor(IERC20 _token, address _forwarder) {
        token = _token;
        _setTrustedForwarder(_forwarder);
    }

    modifier hasBalance(uint256 _amount) {
        require(
            token.balanceOf(_msgSender()) >= _amount,
            "Insufficient balance"
        );
        _;
    }

    function transferFrom(
        address _to,
        uint256 _amount
    ) external hasBalance(_amount) {
        token.transferFrom(_msgSender(), _to, _amount);
    }

    function approve(
        address _contractAddress,
        uint256 _amount
    ) external returns (bool _approved) {
        _approved = token.approve(_contractAddress, _amount);
    }

    function getAllowance(
        address _owner
    ) external view returns (uint256 _allowance) {
        _allowance = token.allowance(_owner, address(this));
    }

    function transferEther(address payable _to) public payable {
        _to.transfer(msg.value);
    }
}