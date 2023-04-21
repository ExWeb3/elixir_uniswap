defmodule Uniswap.Contracts.SwapRouter do
  @moduledoc """
  Uniswap's Swap Router V2
  """

  @abi_file Path.join(
              :code.priv_dir(:uniswap),
              "node_modules/@uniswap/v3-periphery/artifacts/contracts/SwapRouter.sol/SwapRouter.json"
            )
  @default_address "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
