// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "./Hevm.sol";
import "../ZorbFridge.sol";
import "./ZorbMock.sol";
import "./SharedMetadataMock.sol";

contract User {}

contract ZorbFridgeTest is DSTest {
    event Frozen(address indexed actor, uint256 tokenId);
    event Unfrozen(address indexed actor, uint256 tokenId);

    User internal user;
    Hevm internal hevm;
    uint256 internal zorbId;
    ZorbMock internal zorb;
    ZorbFridge internal fridge;

    function setUp() public {
        user = new User();
        zorb = new ZorbMock();
        hevm = Hevm(HEVM_ADDRESS);
        fridge = new ZorbFridge(zorb, new PublicSharedMetadata());

        // Make sure the ZorbFridge can access the zorbs
        zorb.setApprovalForAll(address(fridge), true);

        // Mint a Zorb
        zorbId = zorb.mint();
    }

    function testOwnerCanFreeze() public {
        assertEq(zorb.ownerOf(zorbId), address(this));
        assertEq(fridge.ownerOf(zorbId), address(0));

        hevm.expectEmit(true, false, false, true);
        emit Frozen(address(this), zorbId);

        fridge.freeze(zorbId);
        assertEq(zorb.ownerOf(zorbId), address(fridge));
        assertEq(fridge.ownerOf(zorbId), address(this));
    }

    function testNonOwnerCannotFreeze() public {
        assertEq(zorb.ownerOf(zorbId), address(this));
        assertEq(fridge.ownerOf(zorbId), address(0));

        hevm.prank(address(user));
        // Error message here comes from Solmate (`transferFrom` auth check) and will be different on Zorb contract.
        // This doesn't really matter for tests tho.
        hevm.expectRevert("WRONG_FROM");

        fridge.freeze(zorbId);

        assertEq(zorb.ownerOf(zorbId), address(this));
        assertEq(fridge.ownerOf(zorbId), address(0));
    }

    function testOwnerCanUnfreeze() public {
        fridge.freeze(zorbId);
        assertEq(zorb.ownerOf(zorbId), address(fridge));
        assertEq(fridge.ownerOf(zorbId), address(this));

        hevm.expectEmit(true, false, false, true);
        emit Unfrozen(address(this), zorbId);

        fridge.unfreeze(zorbId);
        assertEq(zorb.ownerOf(zorbId), address(this));
        assertEq(fridge.ownerOf(zorbId), address(0));
    }

    function testNonOwnerCannotUnfreeze() public {
        fridge.freeze(zorbId);
        assertEq(zorb.ownerOf(zorbId), address(fridge));
        assertEq(fridge.ownerOf(zorbId), address(this));

        hevm.prank(address(user));
        hevm.expectRevert("not owner");

        fridge.unfreeze(zorbId);

        assertEq(zorb.ownerOf(zorbId), address(fridge));
        assertEq(fridge.ownerOf(zorbId), address(this));
    }
}
