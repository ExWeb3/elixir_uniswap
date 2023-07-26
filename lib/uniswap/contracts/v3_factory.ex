defmodule Uniswap.Contracts.V3Factory do
  @moduledoc """
  Uniswap V3 Factory Contract
  """

  import Uniswap.Contracts.Utils

  @abi_file abi_path("v3-core", "UniswapV3Factory.sol/UniswapV3Factory.json")
  @default_address "0x1F98431c8aD98523631AE4a59f267346ea31F984"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
