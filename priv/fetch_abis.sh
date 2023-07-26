#!/bin/bash -e

echo "Installing deps with yarn"
yarn install


# move contract abi files out of node_modules
mkdir -p abis/v3-core
cp -r node_modules/@uniswap/v3-core/artifacts/contracts/* abis/v3-core/

mkdir -p abis/v3-periphery
cp -r node_modules/@uniswap/v3-periphery/artifacts/contracts/* abis/v3-periphery/

echo "Contract ABIs refreshed!"
