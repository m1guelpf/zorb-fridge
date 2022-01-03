// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

interface IZorbLike {
    function transferFrom(
        address from,
        address to,
        uint256 id
    ) external;

    function tokenURI(uint256 id) external view returns (string memory);

    function getZorbRenderAddress(uint256 tokenId)
        external
        view
        returns (address);

    function zorbForAddress(address user) external view returns (string memory);
}
