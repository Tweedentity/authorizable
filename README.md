# Authorizable Smart Contract

This contract allows minimalistic governance.

### Levels

`Authorizable` allows an unlimited number of levels.

Any authorized address has an assigned level.

By default, `Authorizable` has `maxLevel = 64` and `authorizerLevel = 56`. The first is the top level accepted. The second is the minimum level requested to an address to be allowed to authorize other addresses.

The function `setLevels` allows to set the variables above, but only when there are no authorized addresses. After than someone has been authorized, the default levels cannot be changed to avoid unfixable errors. To change them, you should call `deAuthorizeAll` and restart :-(

Any level is an `uint`, but you can extend the contract and add helper variables, like, for example:

```
uint public operatorLevel = 6;
uint public teamManagerLevel = 10;
uint public CTOLevel = 32;
uint public CEOLevel = 50;
```

### Modifiers

`Authorizable` offers many modifiers, in order to cover all the simple cases. Extending the contract, you can add more complex modifiers. Here is the list:

`onlyAuthorized` allows any authorized address

`onlyAuthorizedAtLevel(uint _level)` allows only authorized addresses at level `l`

`onlyAuthorizedAtLevels(uint[] _levels)` allows only authorized addresses at any of levels listed in the array `ll`

`onlyAuthorizedAtLevelsWithin(uint minLevel, uint maxLevel)` allows only authorized addresses at level in between the interval

The followings are the same as above but allow also the owner:

```
onlyOwnerOrAuthorized
onlyOwnerOrAuthorizedAtLevel
onlyOwnerOrAuthorizedAtLevels
onlyOwnerOrAuthorizedAtLevelsWithin
```
Finally

`onlyAuthorizer` allows owner and authorized addresses at `level >= authorizerLevel`. It's equivalent to `onlyOwnerOrAuthorizedAtLevelsWithin(authorizerLevel, maxLevel)`.


### Examples

To allow only level >= 10, you can set a function like this

```
function some() onlyAuthorizedAtLevelsWithin(10, maxLevel) {
  ...
}
```


To allow only level 3 and 6 to call a specifif function, you can do something like

```
uint[] public levels = [3, 6]

function some() onlyAuthorizedAtLevels(levels) {
  ...
}
```
Notice that if you try to do
```
function some() onlyAuthorizedAtLevels([3, 6]) {
  ...
}
```
you will have a compilation error because `[3, 6]` is taken as a `uint2[]` array and is not implicitly convertible to `uint[]`.

### Installation and tests

First off, you need to install globally Truffle and Ganachi-cli

`npm install -g ganachi-cli truffle`

After, you can complete the installation with

`npm install && truffle install`

Finally, you start the test server in one terminal with

`ganachi-cli`

and in another terminal

`truffle test`

### Usage

To use Authorizable in a Truffle project install it 
```
npm i -D authorizable
```

and, in you contract, import it like the following example
```
pragma solidity ^0.4.18;


import 'authorizable/contracts/Authorizable.sol';

contract Contract is Authorizable {
  // your code here
}
```

Alternatively, save the `flattened/Authorizable.sol` contract wherever you need it.

### API

**authorize(address _address, uint _level) onlyAuthorizer**  
Allows any authorizer (owner and levels >= authorizerLevel) to authorize a wallet at a specific level, or to revocate the authorization if the `_level` is 0.

**authorizeBatch(address[] _addresses, uint _level) onlyAuthorizer**  
Allows any authorizer to authorize a list of wallets at a specific level (useful, for example, during whitelisting processes).

**deAuthorizeAll() onlyOwner**  
Allows the owner to revocate authorization to all the authorized wallets. This function has a safety check of the `gasleft()` to avoid going out of gas. If, for example, you are trying to remove all the wallets that where whitelisted to participate in an ICO, you could have 10,000 wallets there. In this case the function would require too much gas and it would it the gas limit resulting in a not-executable function.   
To avoid this, the function interrupts the process when there is no more gas left, requiring that you call it again and again until you don't reach the wanted result. 
 
**deAuthorizeAllAtLevel(uint _level) onlyAuthorizer**  
Allows any authorizer to revocate the authorization to any wallet at the specified level.

**deAuthorize() onlyAuthorized**  
Allows any authorized wallets to revocate its own authorization.

**setLevels(uint _maxLevel, uint _authorizerLevel) onlyOwner**  
Allows to set the default levels. This can be done only if `totalAuthorized` is equal to zero, to avoid conflicts and unpredictable errors.

**setSelfRevoke(bool _selfRevoke) onlyOwner**  
Allows to decide if an authorized wallet is able to revoke its own authorization. By default, it is allowed.



### License

MIT.

### Copyright

(c) 2018, Francesco Sullo <francesco@sullo.co>, 0xNIL


