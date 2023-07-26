defmodule Uniswap.Contracts.NonfungiblePositionManager do
  @moduledoc """
  Uniswap's NFT Position Manager
  """
  import Uniswap.Contracts.Utils

  @abi_file abi_path(
              "v3-periphery",
              "NonfungiblePositionManager.sol/NonfungiblePositionManager.json"
            )
  @default_address "0xC36442b4a4522E871399CD717aBDD847Ab11FE88"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
