defmodule Uniswap.Liquidity.UtilsTest do
  use ExUnit.Case
  doctest Uniswap.Liquidity.Utils

  alias Uniswap.Liquidity.Utils
  alias Uniswap.Tick

  @liquidity_threshold 50

  test "with real data" do
    liquidity = 140_515_708_507_706_331

    lower_tick = -278_700
    upper_tick = -273_600

    {:ok, lower_ratio} = Tick.Math.get_sqrt_ratio_at_tick(lower_tick)
    {:ok, upper_ratio} = Tick.Math.get_sqrt_ratio_at_tick(upper_tick)
    current_ratio = 75_413_095_348_104_808_367_850

    assert {amount_0, amount_1} =
             Utils.get_amounts_for_liquidity(liquidity, current_ratio, lower_ratio, upper_ratio)

    assert amount_0 == 24_999_999_997_779_425_222_193
    assert amount_1 == 8_972_666_308

    re_liquidity =
      Utils.get_liquidity_for_amounts(
        amount_0,
        # adding one to account for reminders
        amount_1 + 1,
        current_ratio,
        lower_ratio,
        upper_ratio
      )

    assert abs(re_liquidity - liquidity) <= @liquidity_threshold
  end

  test "with position number 2 data" do
    liquidity = 5_004_457_838_393_877_976
    tick_lower = -276_330
    tick_upper = -276_320
    sqrt_ratio = 79_241_655_568_255_329_642_264

    lower_tick_sqrt = Tick.Math.get_sqrt_ratio_at_tick!(tick_lower)
    upper_tick_sqrt = Tick.Math.get_sqrt_ratio_at_tick!(tick_upper)

    {token_0_amount, token_1_amount} =
      Utils.get_amounts_for_liquidity(liquidity, sqrt_ratio, lower_tick_sqrt, upper_tick_sqrt)

    assert abs(
             Utils.get_liquidity_for_amounts(
               token_0_amount,
               token_1_amount + 1,
               sqrt_ratio,
               lower_tick_sqrt,
               upper_tick_sqrt
             ) - liquidity
           ) < @liquidity_threshold
  end
end
