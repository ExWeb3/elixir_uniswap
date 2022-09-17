defmodule Uniswap.Liquidity.UtilsTest do
  use ExUnit.Case
  doctest Uniswap.Liquidity.Utils

  alias Uniswap.Liquidity.Utils

  describe "get_liquidity_for_amounts/7" do
    test "with on-chain data" do
      amount_0 = 1244.2721282001135
      amount_1 = 0
      price = 1 / 2000
      price_a = 1 / 1474.4463585092642
      price_b = 1 / 1813.5245551669193
      decimals_0 = 6
      decimals_1 = 18
      liquidity = 297_176_747_167_880

      assert liquidity ==
               Utils.get_liquidity_for_amounts(
                 amount_0,
                 amount_1,
                 price,
                 price_a,
                 price_b,
                 decimals_0,
                 decimals_1
               )
    end
  end
end
