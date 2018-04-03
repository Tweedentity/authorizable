pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';


// @title Authorizable
// @author Francesco Sullo <francesco@sullo.co>
// The Authorizable contract provides authorization control functions.

/*
  The level is a uint <= maxLevel (64 by default)
  
    0 means not authorized
    1..maxLevel means authorized

  Having more levels allows to create hierarchical roles.
  For example:
    ...
    operatorLevel: 6
    teamManagerLevel: 10
    ...
    CTOLevel: 32
    ...

  If the owner wants to execute functions which require explicit authorization, it must authorize itself.
  
  If you need complex level, in the extended contract, you can add a function to generate unique roles based on combination of levels. The possibilities are almost unlimited, since the level is a uint256
*/

contract Authorizable is Ownable {

  uint public totalAuthorized;

  mapping(address => uint) public authorized;
  address[] internal __authorized;

  event AuthorizedAdded(address _authorizer, address _authorized, uint _level);

  event AuthorizedRemoved(address _authorizer, address _authorized);

  uint public maxLevel = 64;
  uint public authorizerLevel = 56;

  function setLevels(uint _maxLevel, uint _authorizerLevel) external onlyOwner {
    // this must be called before authorizing any address
    require(totalAuthorized == 0);
    require(_maxLevel > 0 && _authorizerLevel > 0);
    require(_maxLevel >= _authorizerLevel);

    maxLevel = _maxLevel;
    authorizerLevel = _authorizerLevel;
  }

  // Throws if called by any account which is not authorized.
  modifier onlyAuthorized() {
    require(authorized[msg.sender] > 0);
    _;
  }

  // Throws if called by any account which is not authorized at a specific level.
  modifier onlyAuthorizedAtLevel(uint _level) {
    require(authorized[msg.sender] == _level);
    _;
  }

  // Throws if called by any account which is not authorized at some of the specified levels.
  modifier onlyAuthorizedAtLevels(uint[] _levels) {
    require(__hasLevel(authorized[msg.sender], _levels));
    _;
  }

  // Throws if called by any account which has a level of authorization not in the interval
  modifier onlyAuthorizedAtLevelsBetween(uint _level1, uint _level2) {
    require(authorized[msg.sender] > _level1 && authorized[msg.sender] < _level2);
    _;
  }

  // same modifiers but including the owner

  modifier onlyOwnerOrAuthorized() {
    require(msg.sender == owner || authorized[msg.sender] > 0);
    _;
  }

  modifier onlyOwnerOrAuthorizedAtLevel(uint _level) {
    require(msg.sender == owner || authorized[msg.sender] == _level);
    _;
  }

  modifier onlyOwnerOrAuthorizedAtLevels(uint[] _levels) {
    require(msg.sender == owner || __hasLevel(authorized[msg.sender], _levels));
    _;
  }

  modifier onlyOwnerOrAuthorizedAtLevelsBetween(uint _level1, uint _level2) {
    require(msg.sender == owner || (authorized[msg.sender] > _level1 && authorized[msg.sender] < _level2));
    _;
  }

  // Throws if called by anyone who is not an authorizer.
  modifier onlyAuthorizer() {
    require(msg.sender == owner || authorized[msg.sender] >= authorizerLevel);
    _;
  }


  // methods

  // Allows the current owner and authorized with level >= authorizerLevel to add a new authorized address, or remove it, setting _level to 0
  function authorize(address _address, uint _level) onlyAuthorizer external {
    __authorize(_address, _level);
  }

  // Allows the current owner to remove all the authorizations.
  function deAuthorizeAll() onlyOwner external {
    for (uint i = 0; i < __authorized.length; i++) {
      if (__authorized[i] != address(0)) {
        __authorize(__authorized[i], 0);
      }
    }
  }

  // Allows an authorized to de-authorize itself.
  function deAuthorize() onlyAuthorized external {
    __authorize(msg.sender, 0);
  }

  // internal functions
  function __authorize(address _address, uint _level) internal {
    require(_address != address(0));
    require(_level >= 0 && _level <= maxLevel);

    uint i;
    if (_level > 0) {
      bool alreadyIndexed = false;
      for (i = 0; i < __authorized.length; i++) {
        if (__authorized[i] == _address) {
          alreadyIndexed = true;
          break;
        }
      }
      if (alreadyIndexed == false) {
        __authorized.push(_address);
        totalAuthorized++;
      }
      AuthorizedAdded(msg.sender, _address, _level);
      authorized[_address] = _level;
    } else {
      for (i = 0; i < __authorized.length; i++) {
        if (__authorized[i] == _address) {
          __authorized[i] = address(0);
          totalAuthorized--;
          break;
        }
      }
      AuthorizedRemoved(msg.sender, _address);
      delete authorized[_address];
    }
  }

  function __hasLevel(uint _level, uint[] _levels) internal pure returns (bool) {
    bool has = false;
    for (uint i; i < _levels.length; i++) {
      if (_level == _levels[i]) {
        has = true;
        break;
      }
    }
    return has;
  }

  // helpers callable by other contracts

  function amIAuthorized() external constant returns (bool) {
    return authorized[msg.sender] > 0;
  }

  function getLevelOfAuthorization() external constant returns (uint) {
    return authorized[msg.sender];
  }

}
