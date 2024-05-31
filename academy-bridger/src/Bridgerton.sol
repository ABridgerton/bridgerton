// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/erc20/IERC20.sol";
import {ABridgerToken} from "./ABridgerToken.sol";
import {WrappedABridgerToken} from "./WrappedABridgerToken.sol";
import {IBridgerton} from "./interfaces/IBridgerton.sol";

contract Bridgerton is IBridgerton {
    address public admin;
    ABridgerToken public mainToken;
    WrappedABridgerToken public wrappedToken;
    mapping(address => uint256) public lockedBalance;

    event LockTokens(address indexed user, uint256 amount);
    event UnlockTokens(address indexed user, uint256 amount, address indexed admin);
    event MintWrappedToken(address indexed user, uint256 amount, address indexed admin);
    event BurnWrappedToken(address indexed user, uint256 amount, address indexed admin);

    constructor(address _mainTokenAddress) {
        admin = msg.sender;
        if (_mainTokenAddress != address(0)) {
            mainToken = ABridgerToken(_mainTokenAddress);
        }

        wrappedToken = new WrappedABridgerToken();
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "User is not an admin");
        _;
    }

    modifier sufficientBalance(address _user, uint256 _amount) {
        require(lockedBalance[_user] >= _amount, "Insufficient locked balance");
        _;
    }

    modifier nonZeroAmount(uint256 _amount) {
        require(_amount > 0, "Amount must be greater than zero");
        _;
    }

    function lockTokens(uint256 _amount) external nonZeroAmount(_amount) {
        require(address(mainToken) != address(0), "MainToken not initialized");
        require(mainToken.allowance(msg.sender, address(this)) >= _amount, "Allowance not set or insufficient");
        require(mainToken.balanceOf(msg.sender) >= _amount, "Insufficient token balance");

        lockedBalance[msg.sender] += _amount;
        require(mainToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        emit LockTokens(msg.sender, _amount);
    }

    function unlockTokens(address _user, uint256 _amount)
        external
        onlyAdmin
        sufficientBalance(_user, _amount)
        nonZeroAmount(_amount)
    {
        require(address(mainToken) != address(0), "MainToken not initialized");

        require(mainToken.transfer(_user, _amount), "Transfer failed");
        lockedBalance[_user] -= _amount;

        emit UnlockTokens(_user, _amount, msg.sender);
    }

    function mintWrappedTokens(address _user, uint256 _amount) external onlyAdmin nonZeroAmount(_amount) {
        require(_user != address(0), "Cannot mint to zero address");

        wrappedToken.mint(_user, _amount);

        emit MintWrappedToken(_user, _amount, msg.sender);
    }

    function burnWrappedTokens(address _user, uint256 _amount) external onlyAdmin nonZeroAmount(_amount) {
        require(_user != address(0), "Invalid user address");
        require(wrappedToken.allowance(_user, address(this)) >= _amount, "Allowance not set or insufficient");
        require(wrappedToken.balanceOf(_user) >= _amount, "Insufficient wrapped token balance");

        require(wrappedToken.transferFrom(_user, address(this), _amount), "Transfer failed");

        wrappedToken.burn(address(this), _amount);

        emit BurnWrappedToken(_user, _amount, msg.sender);
    }

    function getLockedBalance(address _user) external view returns (uint256) {
        return lockedBalance[_user];
    }
}
