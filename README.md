# Authorizable Smart Contract

This contract allows minimalistic governance.

### Levels

`Authorizable` allows an unlimited number of levels.

Any authorized address receives an assigned level.

By default, `Authorizable` has `maxLevel = 64` and `authorizerLevel = 56`. The first is the top level accepted. The second is the minimum level requested to an address allowed to authorize other addresses.

The function `setLevels` allows to set the variables above, but only when there are no authorized addresses. After than someone has been authorized, the default levels cannot be changed to avoid unfixable errors.

Any role is an `uint`, but you can extend the contract and add helper variable, like, for example:

```
uint public operatorLevel = 6;
uint public teamManagerLevel = 10;
uint public CTOLevel = 32;
uint public CEOLevel = 50;
```

### Modifiers

`Authorizable` offers many modifiers, in order to cover all the simple cases. Extending the contract, you can add more complex modifiers. Here is the list:

```
onlyAuthorized
onlyAuthorizedAtLevel(l)
onlyAuthorizedAtLevels(ll)
onlyAuthorizedAtLevelMoreThan(l)
onlyAuthorizedAtLevelLessThan(l)
onlyOwnerOrAuthorized
onlyOwnerOrAuthorizedAtLevel(l)
onlyOwnerOrAuthorizedAtLevels(ll)
onlyOwnerOrAuthorizedAtLevelMoreThan(l)
onlyOwnerOrAuthorizedAtLevelLessThan(l)
onlyAuthorizer
```

### Examples

To allow only level >= 10, you can set a function like this

```
function some() onlyAuthorizedAtLevelMoreThan(9) {
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

### License

MIT.

### Copyright

(c) 2018, Francesco Sullo <francesco@sullo.co>, 0xNIL


