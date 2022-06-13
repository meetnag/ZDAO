// contracts/Holder.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./IToken.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

contract Holder is ERC1155Receiver {

   IToken private _IToken;
    
    constructor(IToken TokenAddress) {
        _IToken = TokenAddress;
    }

    function onERC1155Received(
        address from,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        console.log(msg.sender);
        _IToken.mint(from, 1);
        return this.onERC1155Received.selector;
    }


    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
    
    function transferItems(IERC1155 ERC1155Address, uint256 _itemId, uint256 _amount, address _from, address _to) external {
        IERC1155 _IERC1155 = ERC1155Address;
        require(_IERC1155.balanceOf(_from, _itemId) >= _amount);
        _IERC1155.safeTransferFrom(_from, _to, _itemId, _amount, "");
    }

    // function validateERC1155Contract() public view {
    //     IERC1155 _IERC1155 = IERC1155(address(0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d));
    //     console.log(_IERC1155.name);
    // }

}