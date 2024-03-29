defmodule Uniswap.Liquidity do
  @moduledoc """
  Manage Liquidity on Uniswap contracts
  """
  alias Uniswap.Contracts.NonfungiblePositionManager
  alias Uniswap.Liquidity.Position

  def list_positions(owner, opts \\ []) do
    num_positions = NonfungiblePositionManager.balance_of(owner) |> Ethers.call!(opts)

    Enum.map(0..(num_positions - 1), fn pos_idx ->
      NonfungiblePositionManager.token_of_owner_by_index(owner, pos_idx) |> Ethers.call!(opts)
    end)
    |> Enum.map(&{&1, Ethers.call!(NonfungiblePositionManager.positions(&1), opts)})
    |> Enum.map(&Position.parse/1)
  end
end
