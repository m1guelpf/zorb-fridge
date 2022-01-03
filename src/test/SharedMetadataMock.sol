// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "../interfaces/IPublicSharedMetadata.sol";

contract PublicSharedMetadata is IPublicSharedMetadata {
    function encodeMetadataJSON(bytes memory)
        external
        pure
        returns (string memory)
    {
        return "";
    }

    function numberToString(uint256) external pure returns (string memory) {
        return "";
    }
}
