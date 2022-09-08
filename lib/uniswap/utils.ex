defmodule Uniswap.Utils do
  @moduledoc """
  Helper functions for calculation and interaction with Uniswap DEX.
  """

  @tick_base 1.0001

  @doc """
  Converts a price to it's corresponding tick

  ## Examples

  iex> Uniswap.Utils.price_to_tick(1813.5245551669193, 10, 6, 18)
  201290

  iex> Uniswap.Utils.price_to_tick(1474.4, 10, 6, 18)
  203360
  """
  def price_to_tick(price, tick_spacing, token0_decimals \\ 18, token1_decimals \\ 18) do
    (:math.log(1 / price / :math.pow(10, token0_decimals - token1_decimals)) /
       :math.log(@tick_base))
    |> round()
    |> nearest_tick(tick_spacing)
  end

  @doc """
  Converts a tick to it's corresponding price

  ## Examples

  iex> Uniswap.Utils.tick_to_price(201290, 6, 18)
  1813.5245551669193

  iex> Uniswap.Utils.tick_to_price(203360, 6, 18)
  1474.4463585092642
  """
  def tick_to_price(price, token0_decimals \\ 18, token1_decimals \\ 18) do
    1 / (:math.pow(@tick_base, price) * :math.pow(10, token0_decimals - token1_decimals))
  end

  @doc """
  Returns the nearest tick with respect to tick spacing

  ## Examples

  iex> Uniswap.Utils.nearest_tick(23, 2)
  24

  iex> Uniswap.Utils.nearest_tick(44, 10)
  40

  iex> Uniswap.Utils.nearest_tick(45, 10)
  50

  iex> Uniswap.Utils.nearest_tick(46, 10)
  50
  """
  def nearest_tick(tick, spacing) do
    spacing * round(tick / spacing)
  end
end
