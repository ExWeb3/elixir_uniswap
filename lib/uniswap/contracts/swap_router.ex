defmodule Uniswap.Contracts.SwapRouter do
  @moduledoc """
  Uniswap's Swap Router V2
  """
  import Uniswap.Contracts.Utils

  @abi_file abi_path("v3-periphery", "SwapRouter.sol/SwapRouter.json")
  @default_address "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
