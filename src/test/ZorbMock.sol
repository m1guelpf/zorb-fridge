// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "../interfaces/IZorbLike.sol";
import "solmate/tokens/ERC721.sol";

contract ZorbMock is IZorbLike, ERC721 {
    uint256 public tokenId = 1;

    constructor() ERC721("Zorb Mock", "ZORB") {}

    function tokenURI(uint256)
        public
        pure
        override(ERC721, IZorbLike)
        returns (string memory)
    {
        return "";
    }

    function getZorbRenderAddress(uint256) external view returns (address) {
        return msg.sender;
    }

    function zorbForAddress(address) external pure returns (string memory) {
        return "hi i'm a zorb";
    }

    function mint() external returns (uint256) {
        _mint(msg.sender, tokenId);

        return tokenId++;
    }

    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public override(IZorbLike, ERC721) {
        ERC721.transferFrom(from, to, id);
    }
}
