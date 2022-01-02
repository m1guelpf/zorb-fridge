// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

interface IPublicSharedMetadata {
    function encodeMetadataJSON(bytes memory json)
        external
        pure
        returns (string memory);

    function numberToString(uint256 value)
        external
        pure
        returns (string memory);
}
