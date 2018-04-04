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

`onlyAuthorizer` allows owner and authorized addresses at `level >= authorizerLevel`


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

### License

MIT.

### Copyright

(c) 2018, Francesco Sullo <francesco@sullo.co>, 0xNIL


