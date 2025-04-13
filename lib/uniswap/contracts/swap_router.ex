defmodule Uniswap.Contracts.SwapRouter do
  @moduledoc """
  Uniswap's Swap Router V2
  """
  import Uniswap.Contracts.Utils

  @abi_file abi_path("v3-periphery", "SwapRouter.sol/SwapRouter.json")
  @default_address "0xE592427A0AEce92De3Edee1F18E0157C05861564"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
