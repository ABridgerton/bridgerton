// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IBridgerton {
    function lockTokens(uint256 _amount) external;

    function unlockTokens(address _user, uint256 _amount) external;

    function mintWrappedTokens(address _user, uint256 _amount) external;

    function burnWrappedTokens(address _user, uint256 _amount) external;

    function getLockedBalance(address _user) external view returns (uint256);
}
