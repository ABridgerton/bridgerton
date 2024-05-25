// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../lib/openzeppelin-contracts/contracts/token/erc20/IERC20.sol";
import {ABridgerToken} from "./ABridgerToken.sol";
import {WrappedABridgerToken} from "./WrappedABridgerToken.sol";

contract Bridgerton {
    address public admin;
    ABridgerToken public mainToken;
    WrappedABridgerToken public wrappedToken;
    mapping(address => uint256) public lockedBalance;

    event LockTokens(address user, uint256 amount);
    event UnlockTokens(address user, uint256 amount);
    event MintWrappedToken(address user, uint256 amount);
    event BurnWrappedToken(address user, uint256 amount);

    constructor(address _mainToken, address _wrappedToken) {
        admin = msg.sender;
        mainToken = ABridgerToken(_mainToken);
        wrappedToken = WrappedABridgerToken(_wrappedToken);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "User is not an admin");
        _;
    }

    function lockTokens(uint256 _amount) external {
        lockedBalance[msg.sender] += _amount;
        require(
            mainToken.transferFrom(msg.sender, address(this), _amount),
            "Transfer failed"
        );

        emit LockTokens(msg.sender, _amount);
    }

    function unlockTokens(address _user, uint256 _amount) external onlyAdmin {
        lockedBalance[_user] -= _amount;
        require(mainToken.transfer(_user, _amount), "Transfer failed");

        emit UnlockTokens(msg.sender, _amount);
    }

    function mintWrappedTokens(
        address _user,
        uint256 _amount
    ) external onlyAdmin {
        WrappedABridgerToken(address(wrappedToken)).mint(_user, _amount);

        emit MintWrappedToken(_user, _amount);
    }

    function burnWrappedTokens(
        address _user,
        uint256 _amount
    ) external onlyAdmin {
        require(
            wrappedToken.transferFrom(_user, address(this), _amount),
            "Transfer failed"
        );
        WrappedABridgerToken(address(wrappedToken)).burn(
            address(this),
            _amount
        );

        emit BurnWrappedToken(_user, _amount);
    }

    function getLockedBalance(address _user) external view returns (uint256) {
        return lockedBalance[_user];
    }
}
