// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";

/**
 * @title FundMe
 * @notice Users can fund with ETH only if the sent value >= MIN_USD (priced via Chainlink ETH/USD).
 *         Owner can withdraw all funds.
 */
contract FundMe {
    // ============ Errors ============
    error NotOwner();
    error InsufficientUsd(uint256 sentUsd, uint256 minUsd);
    error NothingToWithdraw();
    error TransferFailed();

    // ============ Events ============
    event Funded(address indexed from, uint256 amountWei, uint256 amountUsd18);
    event Withdrawn(address indexed to, uint256 amountWei);

    // ============ State ============
    address public immutable owner;
    AggregatorV3Interface public immutable priceFeed;

    uint256 public constant MIN_USD = 50e18; // $50 with 18 decimals

    mapping(address => uint256) public contributions;
    address[] public funders;

    // ============ Modifiers ============
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // ============ Constructor ============
    constructor(address priceFeedAddress) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    // ============ Funding ============
    function fund() public payable {
        // Compute USD value (18 decimals) of the sent ETH
        uint256 usdValue18 = _ethToUsd(msg.value);
        if (usdValue18 < MIN_USD) revert InsufficientUsd(usdValue18, MIN_USD);

        if (contributions[msg.sender] == 0) {
            funders.push(msg.sender);
        }
        contributions[msg.sender] += msg.value;

        emit Funded(msg.sender, msg.value, usdValue18);
    }

    // ============ Withdrawal ============
    function withdraw() external onlyOwner {
        uint256 bal = address(this).balance;
        if (bal == 0) revert NothingToWithdraw();

        // reset contributions
        for (uint256 i = 0; i < funders.length; i++) {
            contributions[funders[i]] = 0;
        }
        delete funders;

        (bool ok, ) = payable(owner).call{value: bal}("");
        if (!ok) revert TransferFailed();

        emit Withdrawn(owner, bal);
    }

    // ============ Views ============
    function getLatestEthUsd() public view returns (uint256 price, uint8 feedDecimals) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        require(answer > 0, "Invalid price");
        feedDecimals = priceFeed.decimals();
        price = uint256(answer);
    }

    function getMinUsd() external pure returns (uint256) {
        return MIN_USD;
    }

    // ============ Receive / Fallback ============
    receive() external payable { fund(); }
    fallback() external payable { fund(); }

    // ============ Internals ============
    function _ethToUsd(uint256 weiAmount) internal view returns (uint256 usdValue18) {
        (uint256 price, uint8 d) = getLatestEthUsd(); // price = USD/ETH * 10^d
        // usdValue(18) = wei(18) * price(d) / 10^d
        usdValue18 = (weiAmount * price) / (10 ** d);
    }
}
