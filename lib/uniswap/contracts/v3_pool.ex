defmodule Uniswap.Contracts.V3Pool do
  @moduledoc """
  Uniswap V3 Pool Contract
  """
  import Uniswap.Contracts.Utils
  alias Uniswap.Contracts.NonfungiblePositionManager

  @abi_file abi_path("v3-core", "UniswapV3Pool.sol/UniswapV3Pool.json")

  use Ethers.Contract, abi_file: @abi_file

  @doc """
  Calculates the position key based PositionKey.sol library implementation

  ## Examples

      iex> V3Pool.position_key(-276330, -276320)
      "0x83947e3b1c37534eabbcccb7343ebdbf5390725cbe77c0d7dae7963d7d8d3a3d"
  """
  def position_key(owner \\ NonfungiblePositionManager.default_address(), lower_tick, upper_tick) do
    address_bin = Ethers.Utils.hex_decode!(owner)

    <<address_bin::binary, lower_tick::signed-24, upper_tick::signed-24>>
    |> ExKeccak.hash_256()
    |> Ethers.Utils.hex_encode()
  end
end
