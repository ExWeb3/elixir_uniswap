defmodule Uniswap.Liquidity.Utils do
  @moduledoc """
  Utilities for handling liquidity calculations

  Provides functions for computing liquidity amounts from token amounts and prices.

  Note that all prices in this module are presented as `token0 / token1`.
  """

  import Bitwise

  @fixed_point_q96_resolution 96
  @fixed_point_q96 0x1000000000000000000000000

  @doc """
  Computes the amount of liquidity received for a given amount of token0 and price range

  Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))

  ## Parameters
  - amount_0: The amount of token0 being sent in.
  - sqrt_ratio_a: A price representing the first tick boundary.
  - sqrt_ratio_b: A price representing the second tick boundary.

  ## Examples

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amount_0(100, 83094576964003990165232822996, 75541653435528998045632568071)
  1048

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amount_0(100, 75541653435528998045632568071, 83094576964003990165232822996)
  1048
  """
  @spec get_liquidity_for_amount_0(number, number, number) ::
          non_neg_integer
  def get_liquidity_for_amount_0(
        amount_0,
        sqrt_ratio_a,
        sqrt_ratio_b
      ) do
    {lower_sqrt_ratio, upper_sqrt_ratio} = sort_prices(sqrt_ratio_a, sqrt_ratio_b)

    intermediate = div(lower_sqrt_ratio * upper_sqrt_ratio, @fixed_point_q96)
    div(amount_0 * intermediate, upper_sqrt_ratio - lower_sqrt_ratio)
  end

  @doc """
  Computes the amount of liquidity received for a given amount of token1 and price range

  Calculates amount1 / (sqrt(upper) - sqrt(lower))


  ## Parameters
  - amount_1: The amount of token1 being sent in.
  - sqrt_ratio_a: A price representing the first tick boundary.
  - sqrt_ratio_b: A price representing the second tick boundary.

  ## Examples

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amount_1(100, 83094576964003990165232822996, 75541653435528998045632568071)
  1048
  """
  @spec get_liquidity_for_amount_1(number, number, number) ::
          non_neg_integer
  def get_liquidity_for_amount_1(
        amount_1,
        sqrt_ratio_a,
        sqrt_ratio_b
      ) do
    {lower_sqrt_ratio, upper_sqrt_ratio} = sort_prices(sqrt_ratio_a, sqrt_ratio_b)

    div(amount_1 * @fixed_point_q96, upper_sqrt_ratio - lower_sqrt_ratio)
  end

  @doc """
  Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
  pool prices and the prices at the tick boundaries.

  Returns the largest possible liquidity for the amounts.

  ## Parameters
  - amount_0: The amount of token0 being sent in.
  - amount_1: The amount of token1 being sent in.
  - current_sqrt_ratio: A price representing the current pool price.
  - sqrt_ratio_a: A price representing the first tick boundary.
  - sqrt_ratio_b: A price representing the second tick boundary.

  ## Examples

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amounts(100, 200, 79228162514264337593543950336, 75541653435528998045632568071, 83094576964003990165232822996)
  2149

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amounts(100, 200, 75161148693683831164828610338, 75541653435528998045632568071, 83094576964003990165232822996)
  1048

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amounts(100, 200, 83473499738992491211565015422, 75541653435528998045632568071, 83094576964003990165232822996)
  2097
  """
  @spec get_liquidity_for_amounts(
          number,
          number,
          number,
          number,
          number
        ) :: non_neg_integer
  def get_liquidity_for_amounts(
        amount_0,
        amount_1,
        current_sqrt_ratio,
        sqrt_ratio_a,
        sqrt_ratio_b
      ) do
    {lower_sqrt_ratio, upper_sqrt_ratio} = sort_prices(sqrt_ratio_a, sqrt_ratio_b)

    cond do
      current_sqrt_ratio <= lower_sqrt_ratio ->
        get_liquidity_for_amount_0(amount_0, lower_sqrt_ratio, upper_sqrt_ratio)

      current_sqrt_ratio < upper_sqrt_ratio ->
        liquidity_0 = get_liquidity_for_amount_0(amount_0, current_sqrt_ratio, upper_sqrt_ratio)
        liquidity_1 = get_liquidity_for_amount_1(amount_1, lower_sqrt_ratio, current_sqrt_ratio)

        min(liquidity_0, liquidity_1)

      true ->
        get_liquidity_for_amount_1(amount_1, lower_sqrt_ratio, upper_sqrt_ratio)
    end
  end

  @doc """
  Computes the amount of token0 for a given amount of liquidity and a price range

  ## Parameters
  - liquidity: The liquidity being valued.
  - sqrt_ratio_a: A price representing the first tick boundary.
  - sqrt_ratio_b: A price representing the second tick boundary.

  ## Examples
  iex> Uniswap.Liquidity.Utils.get_amount_0_for_liquidity(1048, 75541653435528998045632568071, 83094576964003990165232822996)
  99
  """
  @spec get_amount_0_for_liquidity(number, number, number) ::
          float
  def get_amount_0_for_liquidity(liquidity, sqrt_ratio_a, sqrt_ratio_b) do
    {lower_sqrt_ratio, upper_sqrt_ratio} = sort_prices(sqrt_ratio_a, sqrt_ratio_b)

    ((liquidity <<< @fixed_point_q96_resolution) * (upper_sqrt_ratio - lower_sqrt_ratio))
    |> div(upper_sqrt_ratio)
    |> div(lower_sqrt_ratio)
  end

  @doc """
  Computes the amount of token1 for a given amount of liquidity and a price range

  ## Parameters
  - liquidity: The liquidity being valued.
  - sqrt_ratio_a: A price representing the first tick boundary.
  - sqrt_ratio_b: A price representing the second tick boundary.

  ## Examples
  iex> Uniswap.Liquidity.Utils.get_amount_0_for_liquidity(2097, 75541653435528998045632568071, 83094576964003990165232822996)
  199
  """
  @spec get_amount_1_for_liquidity(number, number, number) ::
          float
  def get_amount_1_for_liquidity(liquidity, sqrt_ratio_a, sqrt_ratio_b) do
    {lower_sqrt_ratio, upper_sqrt_ratio} = sort_prices(sqrt_ratio_a, sqrt_ratio_b)

    div(liquidity * (upper_sqrt_ratio - lower_sqrt_ratio), @fixed_point_q96)
  end

  @doc """
  Computes the token0 and token1 value for a given amount of liquidity, the current
  pool prices and the prices at the tick boundaries.

  Returns amounts in a 2 element tuple: `{amount_token_0, amount_token_1}`

  ## Parameters
  - liquidity: The liquidity being valued
  - current_sqrt_ratio: A price representing the current pool price.
  - sqrt_ratio_a: A price representing the first tick boundary.
  - sqrt_ratio_b: A price representing the second tick boundary.

  ## Examples
  iex> Uniswap.Liquidity.Utils.get_amounts_for_liquidity(2148, 79228162514264337593543950336, 75541653435528998045632568071, 83094576964003990165232822996)
  {99, 99}

  iex> Uniswap.Liquidity.Utils.get_amounts_for_liquidity(1048, 75161148693683831164828610338, 75541653435528998045632568071, 83094576964003990165232822996)
  {99, 0}

  iex> Uniswap.Liquidity.Utils.get_amounts_for_liquidity(2097, 83473499738992491211565015422, 75541653435528998045632568071, 83094576964003990165232822996)
  {0, 199}
  """
  @spec get_amounts_for_liquidity(
          number,
          number,
          number,
          number
        ) :: {float, float}
  def get_amounts_for_liquidity(
        liquidity,
        current_sqrt_ratio,
        sqrt_ratio_a,
        sqrt_ratio_b
      ) do
    {lower_sqrt_ratio, upper_sqrt_ratio} = sort_prices(sqrt_ratio_a, sqrt_ratio_b)

    cond do
      current_sqrt_ratio <= lower_sqrt_ratio ->
        {get_amount_0_for_liquidity(
           liquidity,
           lower_sqrt_ratio,
           upper_sqrt_ratio
         ), 0}

      current_sqrt_ratio < upper_sqrt_ratio ->
        {get_amount_0_for_liquidity(
           liquidity,
           current_sqrt_ratio,
           upper_sqrt_ratio
         ),
         get_amount_1_for_liquidity(
           liquidity,
           lower_sqrt_ratio,
           current_sqrt_ratio
         )}

      true ->
        # current_sqrt_ratio >= upper_sqrt_ratio
        {0,
         get_amount_1_for_liquidity(
           liquidity,
           lower_sqrt_ratio,
           upper_sqrt_ratio
         )}
    end
  end

  ## Helpers

  defp sort_prices(price_a, price_b) when price_a < price_b,
    do: {price_a, price_b}

  defp sort_prices(price_a, price_b), do: {price_b, price_a}
end
