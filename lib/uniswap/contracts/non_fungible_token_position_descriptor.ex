defmodule Uniswap.Contracts.NonfungibleTokenPositionDescriptor do
  @moduledoc """
  Uniswap's NFT Position Descriptor
  """

  @abi_file Path.join(
              :code.priv_dir(:uniswap),
              "node_modules/@uniswap/v3-periphery/artifacts/contracts/NonfungibleTokenPositionDescriptor.sol/NonfungibleTokenPositionDescriptor.json"
            )
  @default_address "0x91ae842A5Ffd8d12023116943e72A606179294f3"

  use Ethers.Contract, abi_file: @abi_file, default_address: @default_address
end
