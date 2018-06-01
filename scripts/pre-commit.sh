#!/usr/bin/env bash

truffle test

if [ $? -ne 0 ]; then
 echo "Tests must pass before commit!"
 exit 1
fi

npm run flatten
git add -A
