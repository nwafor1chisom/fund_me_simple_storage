// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @dev Minimal mock that matches AggregatorV3Interface shape for local testing.
contract MockV3Aggregator {
    uint8 private _decimals;
    int256 private _answer;
    uint80 private _roundId;
    uint256 private _timestamp;

    constructor(uint8 decimals_, int256 initialAnswer_) {
        _decimals = decimals_;
        _answer = initialAnswer_;
        _roundId = 1;
        _timestamp = block.timestamp;
    }

    function decimals() external view returns (uint8) { return _decimals; }
    function description() external pure returns (string memory) { return "MockV3Aggregator"; }
    function version() external pure returns (uint256) { return 1; }

    function updateAnswer(int256 newAnswer) external {
        _answer = newAnswer;
        _roundId += 1;
        _timestamp = block.timestamp;
    }

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (_roundId, _answer, _timestamp, _timestamp, _roundId);
    }

    function getRoundData(uint80 roundIdReq)
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (roundIdReq, _answer, _timestamp, _timestamp, _roundId);
    }
}
