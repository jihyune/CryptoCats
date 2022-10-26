// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "./catfactory.sol";

contract CatHelper is CatFactory{

  uint levelUpFee = 0.001 ether;

  modifier onlyOwnerOf(uint _catId) {
    require(msg.sender == catToOwner[_catId]);
    _;
  }

  modifier aboveLevel(uint _level, uint _catId) {
    require(cats[_catId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    // address payable _owner = address(uint160(owner));
    payable(owner).transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _catId) external payable {
    require(msg.value == levelUpFee);
    cats[_catId].level++;
  }

  function changeName(uint _catId, string calldata _newName) external aboveLevel(2, _catId) onlyOwnerOf(_catId) {
    cats[_catId].name = _newName;
  }

  function changeDna(uint _catId, uint _newDna) external aboveLevel(20, _catId) onlyOwnerOf(_catId) {
    cats[_catId].dna = _newDna;
  }

  function getCatsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerCatCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < cats.length; i++) {
      if (catToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
