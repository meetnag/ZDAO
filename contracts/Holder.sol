// contracts/Holder.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IToken.sol";
import "hardhat/console.sol";

contract Holder is ERC1155Receiver {

    address private _erc1155Address;
    address private _tokenAddress;
    address private _owner;
    address private _admin;
    uint[] private _acceptTokenIDs;

    event Received(address operator, address from, uint256 id, uint256 value, bytes data);
    event BatchReceived(address operator, address from, uint256[] ids, uint256[] values, bytes data);

    constructor(address erc1155Address, address tokenAddress, uint[] memory tokenIDs) { 
        require(erc1155Address != address(0), "Address can not be zero");
        require(tokenAddress != address(0), "Address can not be zero");
        _owner = msg.sender;
        _tokenAddress = tokenAddress;
        _erc1155Address = erc1155Address;
        _acceptTokenIDs = tokenIDs;
    }

    modifier onlyOwner {
      require(msg.sender == _owner);
      _;
    }   

    modifier onlyAdmin {
      require(msg.sender == _admin);
      _;
    }

    
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public virtual override returns (bytes4)  {
        console.log(operator);
        console.log(msg.sender);
        console.log(_erc1155Address);
        require(msg.sender == _erc1155Address, "Contract not matched");
        //require(_acceptTokenIDs.includes(id), "Contract not matched");
        IToken(_tokenAddress).mint(operator, 1 * 10**18);
        emit Received(operator, from, id, value, data);
        return this.onERC1155Received.selector;
    }


    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override returns (bytes4) {
        console.log(operator);
        console.log(msg.sender);
        require(msg.sender == _erc1155Address, "Contract not matched");
        IToken(_tokenAddress).mint(operator, ids.length * 10**18);
        emit BatchReceived(operator, from, ids, values, data);
        return this.onERC1155BatchReceived.selector;
    }
    
    function transferItems(uint256 _itemId, uint256 _amount, address _from, address _to) external {
        IERC1155 _IERC1155 = IERC1155(_erc1155Address);
        require( _IERC1155.balanceOf(_from, _itemId) >= _amount);
        _IERC1155.safeTransferFrom(_from, _to, _itemId, _amount, "");
    }

    function setAdmin(address admin) public onlyOwner {
        _admin = admin;
    }

    function setDefaultErc1155Address(address erc1155Address) public onlyAdmin {
        require(erc1155Address != address(0), "Address can not be zero");
        _erc1155Address = erc1155Address;
    }

    function setDefaultTokenAddress(address tokenAddress) public onlyAdmin {
        require(tokenAddress != address(0), "Address can not be zero");
        _tokenAddress = tokenAddress;
    }


    function addAcceptedTokenID(uint tokenID) public onlyAdmin {
        _acceptTokenIDs.push(tokenID);
    }

}