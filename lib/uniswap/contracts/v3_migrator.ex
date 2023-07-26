defmodule Uniswap.Contracts.V3Migrator do
  @moduledoc """
  Uniswap's V3 Migrator
  """
  import Uniswap.Contracts.Utils

  @abi_file abi_path("v3-periphery", "V3Migrator.sol/V3Migrator.json")
  @default_address "0xA5644E29708357803b5A882D272c41cC0dF92B34"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
