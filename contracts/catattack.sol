// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "./cathelper.sol";

contract CatAttack is CatHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function triggerCooldown(Cat storage _cat) internal {
    _cat.readyTime = uint32(block.timestamp + cooldownTime);
  }

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(msg.sender))) % _modulus;
  }

  function attack(uint _catId, uint _targetId) external onlyOwnerOf(_catId) {
    Cat storage myCat = cats[_catId];
    Cat storage enemyCat = cats[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myCat.winCount++;
      myCat.level++;
      enemyCat.lossCount++;
    } else {
      myCat.lossCount++;
      enemyCat.winCount++;
      triggerCooldown(myCat);
    }
  }
}
