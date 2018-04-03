pragma solidity ^0.4.18;

import '../Authorizable.sol';

contract AuthorizableMock is Authorizable {

  function getAuthorizedAddresses() public constant returns (address[]) {
    return __authorized;
  }

  uint public testVariable = 0;

  function setTestVariable1() onlyAuthorized public {
    testVariable = 1;
  }

  function setTestVariable2() onlyAuthorizedAtLevel(5) public {
    testVariable = 2;
  }

  function setTestVariable3() onlyAuthorizedAtLevelsBetween(3, 20) public {
    testVariable = 3;
  }

  function setTestVariable4() onlyOwnerOrAuthorized public {
    testVariable = 4;
  }

  function setTestVariable5() onlyOwnerOrAuthorizedAtLevel(5) public {
    testVariable = 5;
  }

  function setTestVariable6() onlyOwnerOrAuthorizedAtLevelsBetween(4, maxLevel + 1) public {
    testVariable = 6;
  }

  function setTestVariable7() onlyAuthorizedAtLevelsBetween(0, 6) public {
    testVariable = 7;
  }

  function setTestVariable8() onlyAuthorizer public {
    testVariable = 8;
  }

  uint[] public someLevels = [5, 64];

  function setTestVariable9() onlyAuthorizedAtLevels(someLevels) public {
    testVariable = 9;
  }

}