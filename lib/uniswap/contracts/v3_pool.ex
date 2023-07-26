defmodule Uniswap.Contracts.V3Pool do
  @moduledoc """
  Uniswap V3 Pool Contract
  """
  import Uniswap.Contracts.Utils

  @abi_file abi_path("v3-core", "UniswapV3Pool.sol/UniswapV3Pool.json")

  use Ethers.Contract, abi_file: @abi_file
end
