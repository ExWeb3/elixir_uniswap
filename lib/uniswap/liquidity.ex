defmodule Uniswap.Liquidity do
  alias Uniswap.Contracts.NonfungiblePositionManager
  alias Uniswap.Liquidity.Position

  def list_positions(owner, opts \\ []) do
    [num_positions] = NonfungiblePositionManager.balance_of!(owner, opts)

    Enum.map(0..(num_positions - 1), fn pos_idx ->
      [token_id] = NonfungiblePositionManager.token_of_owner_by_index!(owner, pos_idx, opts)
      token_id
    end)
    |> Enum.map(&{&1, NonfungiblePositionManager.positions!(&1, opts)})
    |> Enum.map(&Position.parse/1)
  end
end
