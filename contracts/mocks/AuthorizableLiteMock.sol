pragma solidity ^0.4.18;

import '../AuthorizableLite.sol';

contract AuthorizableLiteMock is AuthorizableLite {

  uint public testVariable = 0;

  function setTestVariable1() onlyAuthorized public {
    testVariable = 1;
  }

  function setTestVariable2() onlyAuthorizedAtLevel(5) public {
    testVariable = 2;
  }

  function setTestVariable4() onlyOwnerOrAuthorized public {
    testVariable = 4;
  }

  function setTestVariable5() onlyOwnerOrAuthorizedAtLevel(5) public {
    testVariable = 5;
  }

  function setTestVariable8() onlyAuthorizer public {
    testVariable = 8;
  }

}