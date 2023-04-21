defmodule Uniswap.Contracts.NonfungiblePositionManager do
  @moduledoc """
  Uniswap's NFT Position Manager
  """

  @abi_file Path.join(
              :code.priv_dir(:uniswap),
              "node_modules/@uniswap/v3-periphery/artifacts/contracts/NonfungiblePositionManager.sol/NonfungiblePositionManager.json"
            )
  @default_address "0xC36442b4a4522E871399CD717aBDD847Ab11FE88"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
