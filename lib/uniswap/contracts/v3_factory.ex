defmodule Uniswap.Contracts.V3Factory do
  @moduledoc """
  Uniswap V3 Factory Contract
  """

  @abi_file Path.join(
              :code.priv_dir(:uniswap),
              "node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Factory.sol/UniswapV3Factory.json"
            )
  @default_address "0x1F98431c8aD98523631AE4a59f267346ea31F984"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
