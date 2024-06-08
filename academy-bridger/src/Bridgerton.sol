// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/erc20/IERC20.sol";
import {Pausable} from "../lib/openzeppelin-contracts/contracts/utils/Pausable.sol";

import {ABridgerToken} from "./ABridgerToken.sol";
import {WrappedToken} from "./WrappedToken.sol";
import {IBridgerton} from "./interfaces/IBridgerton.sol";

contract Bridgerton is IBridgerton, Pausable {
    address public admin;
    mapping(address => address) public sourceToWrappedToken;

    event LockTokens(address indexed user, uint256 amount);
    event MintWrappedTokens(address indexed user, uint256 amount);
    event BurnWrappedTokens(address indexed user, uint256 amount);
    event ReleaseTokens(address indexed user, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier nonZeroAmount(uint256 _amount) {
        require(_amount > 0, "Amount must be greater than zero");
        _;
    }

    function pause() external onlyAdmin {
        _pause();
    }

    function unpause() external onlyAdmin {
        _unpause();
    }

    function lockTokens(address sourceToken, uint256 amount) external whenNotPaused nonZeroAmount(amount) {
        ABridgerToken(sourceToken).transferFrom(msg.sender, address(this), amount);

        emit LockTokens(msg.sender, amount);
    }

    function mintWrappedTokens(address sourceToken, address to, uint256 amount)
        external
        onlyAdmin
        whenNotPaused
        nonZeroAmount(amount)
    {
        address wrappedToken = sourceToWrappedToken[sourceToken];
        if (wrappedToken == address(0)) {
            string memory originalName = ABridgerToken(sourceToken).name();
            string memory originalSymbol = ABridgerToken(sourceToken).symbol();

            string memory wrappedName = string(abi.encodePacked("Wrapped", originalName));
            string memory wrappedSymbol = string(abi.encodePacked("W", originalSymbol));

            WrappedToken newWrappedToken = new WrappedToken(wrappedName, wrappedSymbol);
            wrappedToken = address(newWrappedToken);
            sourceToWrappedToken[sourceToken] = wrappedToken;
        }

        WrappedToken(wrappedToken).mint(to, amount);

        emit MintWrappedTokens(to, amount);
    }

    function burnWrappedTokens(address wrappedToken, address from, uint256 amount)
        external
        onlyAdmin
        whenNotPaused
        nonZeroAmount(amount)
    {
        WrappedToken(wrappedToken).burn(from, amount);

        emit BurnWrappedTokens(from, amount);
    }

    function releaseTokens(address sourceToken, address to, uint256 amount)
        external
        onlyAdmin
        whenNotPaused
        nonZeroAmount(amount)
    {
        require(ABridgerToken(sourceToken).transfer(to, amount), "Token transfer failed");

        emit ReleaseTokens(to, amount);
    }
}
