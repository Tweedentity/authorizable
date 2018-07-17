#!/usr/bin/env bash

contracts=(
"Authorizable"
)

for c in "${contracts[@]}"
do
  truffle-flattener "contracts/$c.sol" > "flattened/$c.sol"
done