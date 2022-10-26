// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "./ownable.sol";
import "./safemath.sol";

contract CatFactory is Ownable {

  using SafeMath for uint256;

  event NewCat(uint catId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Cat {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Cat[] public cats;

  mapping (uint => address) public catToOwner;
  mapping (address => uint) ownerCatCount;

  function _createCat(string memory _name, uint _dna) internal {
    cats.push(Cat(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    uint id = cats.length - 1;
    catToOwner[id] = msg.sender;
    ownerCatCount[msg.sender]++;
    emit NewCat(id, _name, _dna);
  }

  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function createRandomCat(string memory _name) public {
    require(ownerCatCount[msg.sender] > 10);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createCat(_name, randDna);
  }

}
