// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IBridgerton {
    function lockTokens(address sourceToken, uint256 amount) external;

    function mintWrappedTokens(address sourceToken, address to, uint256 amount) external;

    function burnWrappedTokens(address wrappedToken, address from, uint256 amount) external;

    function releaseTokens(address sourceToken, address to, uint256 amount) external;
}
