defmodule Uniswap.Liquidity.UtilsTest do
  use ExUnit.Case
  doctest Uniswap.Liquidity.Utils

  alias Uniswap.Liquidity.Utils
  alias Uniswap.Tick

  test "with real data" do
    liquidity = 600_805_322_452_542_788_569_791

    lower_tick = -157_400
    upper_tick = -156_200

    desired_amount_0 = 91_543_381_284_804_758_704_521_130
    desired_amount_1 = 0

    expected_amount_0 = 91_543_381_284_804_758_704_519_453
    expected_amount_1 = 0

    {:ok, lower_ratio} = Tick.Math.get_sqrt_ratio_at_tick(lower_tick)
    {:ok, upper_ratio} = Tick.Math.get_sqrt_ratio_at_tick(upper_tick)
    current_ratio = 19_878_089_351_077_507_570_309_982

    assert {amount_0, amount_1} =
             Utils.get_amounts_for_liquidity(liquidity, current_ratio, lower_ratio, upper_ratio)

    assert amount_0 == expected_amount_0
    assert amount_1 == expected_amount_1

    assert liquidity ==
             Utils.get_liquidity_for_amounts(
               desired_amount_0,
               desired_amount_1,
               current_ratio,
               lower_ratio,
               upper_ratio
             )
  end
end
