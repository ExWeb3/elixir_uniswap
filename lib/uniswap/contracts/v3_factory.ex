defmodule Uniswap.Contracts.V3Factory do
  @moduledoc """
  Uniswap V3 Factory Contract
  """

  @abi_file Path.join(
              :code.priv_dir(:uniswap),
              "node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Factory.sol/UniswapV3Factory.json"
            )

  use Ethers.Contract, abi_file: @abi_file
end
