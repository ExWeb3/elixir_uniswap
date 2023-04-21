defmodule Uniswap.Contracts.V3Migrator do
  @moduledoc """
  Uniswap's V3 Migrator
  """

  @abi_file Path.join(
              :code.priv_dir(:uniswap),
              "node_modules/@uniswap/v3-periphery/artifacts/contracts/V3Migrator.sol/V3Migrator.json"
            )
  @default_address "0xA5644E29708357803b5A882D272c41cC0dF92B34"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
