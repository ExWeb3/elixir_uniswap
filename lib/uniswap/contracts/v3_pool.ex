defmodule Uniswap.Contracts.V3Pool do
  @moduledoc """
  Uniswap V3 Pool Contract
  """

  @abi_file Path.join(
              :code.priv_dir(:uniswap),
              "node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Pool.sol/UniswapV3Pool.json"
            )

  use Ethers.Contract, abi_file: @abi_file
end
