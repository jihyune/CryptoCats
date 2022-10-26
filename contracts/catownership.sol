// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "./catattack.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./erc721.sol";
import "./safemath.sol";

contract CatOwnership is CatAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) catApprovals;

  function balanceOf(address _owner) public override view returns (uint256 _balance) {
    return ownerCatCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public override view returns (address _owner) {
    return catToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerCatCount[_to] = ownerCatCount[_to].add(1);
    ownerCatCount[msg.sender] = ownerCatCount[msg.sender].sub(1);
    catToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) override public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) override public onlyOwnerOf(_tokenId) {
    catApprovals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) override public {
    require(catApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
