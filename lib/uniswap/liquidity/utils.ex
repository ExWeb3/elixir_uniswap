defmodule Uniswap.Liquidity.Utils do
  @moduledoc """
  Utilities for handling liquidity calculations

  Provides functions for computing liquidity amounts from token amounts and prices

  Note that all prices in this module are presented as `token0/token1`.
  """

  @doc """
  Computes the amount of liquidity received for a given amount of token0 and price range

  Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))

  ## Parameters
  - amount_0: The amount of token0 being sent in.
  - price_a: A price representing the first tick boundary.
  - price_b: A price representing the second tick boundary.
  - decimals_0: Decimal precision of token0. (= ERC20.decimals)
  - decimals_1: Decimal precision of token1. (= ERC20.decimals)

  ## Examples

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amount_0(100, 110/100, 100/110)
  1048
  """
  def get_liquidity_for_amount_0(
        amount_0,
        price_a,
        price_b,
        decimals_0 \\ 18,
        decimals_1 \\ 18
      ) do
    {lower_price, upper_price} = sort_prices(price_a, price_b)
    s_lower_price = sqrtx96(lower_price)
    s_upper_price = sqrtx96(upper_price)

    do_get_liquidity_for_amount_0(amount_0, s_lower_price, s_upper_price)
    |> add_decimals(decimals_0, decimals_1)
    |> trunc()
  end

  @doc """
  Computes the amount of liquidity received for a given amount of token1 and price range

  Calculates amount1 / (sqrt(upper) - sqrt(lower))


  ## Parameters
  - amount_1: The amount of token1 being sent in.
  - price_a: A price representing the first tick boundary.
  - price_b: A price representing the second tick boundary.
  - decimals_0: Decimal precision of token0. (= ERC20.decimals)
  - decimals_1: Decimal precision of token1. (= ERC20.decimals)

  ## Examples

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amount_1(100, 110/100, 100/110)
  1048
  """
  def get_liquidity_for_amount_1(
        amount_1,
        price_a,
        price_b,
        decimals_0 \\ 18,
        decimals_1 \\ 18
      ) do
    {lower_price, upper_price} = sort_prices(price_a, price_b)
    s_lower_price = sqrtx96(lower_price)
    s_upper_price = sqrtx96(upper_price)

    do_get_liquidity_for_amount_1(amount_1, s_lower_price, s_upper_price)
    |> add_decimals(decimals_0, decimals_1)
    |> trunc()
  end

  @doc """
  Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
  pool prices and the prices at the tick boundaries.


  ## Parameters
  - amount_0: The amount of token0 being sent in.
  - amount_1: The amount of token1 being sent in.
  - current_price: A price representing the current pool price.
  - price_a: A price representing the first tick boundary.
  - price_b: A price representing the second tick boundary.
  - decimals_0: Decimal precision of token0. (= ERC20.decimals)
  - decimals_1: Decimal precision of token1. (= ERC20.decimals)

  ## Examples

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amounts(
  ...> 1244.2721282001135, 0, 1/2000, 1/1474.4463585092642, 1/1813.5245551669193, 6, 18
  ...> )
  297176747167880

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amounts(100, 200, 1, 100/110, 110/100)
  2148

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amounts(100, 200, 99/110, 100/110, 110/100)
  1048

  iex> Uniswap.Liquidity.Utils.get_liquidity_for_amounts(100, 200, 111/100, 100/110, 110/100)
  2097
  """
  def get_liquidity_for_amounts(
        amount_0,
        amount_1,
        current_price,
        price_a,
        price_b,
        decimals_0 \\ 18,
        decimals_1 \\ 18
      ) do
    {lower_price, upper_price} = sort_prices(price_a, price_b)
    s_current_price = sqrtx96(current_price)
    s_lower_price = sqrtx96(lower_price)
    s_upper_price = sqrtx96(upper_price)

    cond do
      s_current_price <= s_lower_price ->
        do_get_liquidity_for_amount_0(amount_0, s_lower_price, s_upper_price)

      s_current_price < s_upper_price ->
        liquidity_for_0 = do_get_liquidity_for_amount_0(amount_0, s_current_price, s_upper_price)
        liquidity_for_1 = do_get_liquidity_for_amount_1(amount_1, s_lower_price, s_current_price)

        min(liquidity_for_0, liquidity_for_1)

      true ->
        # s_current_price >= s_upper_price
        do_get_liquidity_for_amount_1(amount_1, s_lower_price, s_upper_price)
    end
    |> add_decimals(decimals_0, decimals_1)
    |> trunc()
  end

  def get_amount_0_for_liquidity(liquidity, price_a, price_b, decimals_0, decimals_1) do
    {lower_price, upper_price} = sort_prices(price_a, price_b)
    s_lower_price = sqrtx96(lower_price)
    s_upper_price = sqrtx96(upper_price)

    do_get_amount_0_for_liquidity(liquidity, s_lower_price, s_upper_price, decimals_0, decimals_1)
  end

  def get_amount_1_for_liquidity(liquidity, price_a, price_b, decimals_0, decimals_1) do
    {lower_price, upper_price} = sort_prices(price_a, price_b)
    s_lower_price = sqrtx96(lower_price)
    s_upper_price = sqrtx96(upper_price)

    do_get_amount_1_for_liquidity(liquidity, s_lower_price, s_upper_price, decimals_0, decimals_1)
  end

  def get_amounts_for_liquidity(
        liquidity,
        current_price,
        price_a,
        price_b,
        decimals_0 \\ 18,
        decimals_1 \\ 18
      ) do
    {lower_price, upper_price} = sort_prices(price_a, price_b)
    s_current_price = sqrtx96(current_price)
    s_lower_price = sqrtx96(lower_price)
    s_upper_price = sqrtx96(upper_price)

    cond do
      s_current_price <= s_lower_price ->
        {do_get_amount_0_for_liquidity(
           liquidity,
           s_lower_price,
           s_upper_price,
           decimals_0,
           decimals_1
         ), 0}

      s_current_price < s_upper_price ->
        {do_get_amount_0_for_liquidity(
           liquidity,
           s_lower_price,
           s_current_price,
           decimals_0,
           decimals_1
         ),
         do_get_amount_1_for_liquidity(
           liquidity,
           s_current_price,
           s_upper_price,
           decimals_0,
           decimals_1
         )}

      true ->
        # s_current_price >= s_upper_price
        {0,
         do_get_amount_1_for_liquidity(
           liquidity,
           s_lower_price,
           s_upper_price,
           decimals_0,
           decimals_1
         )}
    end
  end

  defp do_get_amount_0_for_liquidity(
         liquidity,
         s_lower_price,
         s_upper_price,
         decimals_0,
         decimals_1
       ) do
    (liquidity * (s_upper_price - s_lower_price) / (s_lower_price * s_upper_price))
    |> remove_decimals(decimals_0, decimals_1)
  end

  defp do_get_amount_1_for_liquidity(
         liquidity,
         s_lower_price,
         s_upper_price,
         decimals_0,
         decimals_1
       ) do
    (liquidity * (s_upper_price - s_lower_price))
    |> remove_decimals(decimals_0, decimals_1)
  end

  defp do_get_liquidity_for_amount_0(amount, s_lower_price, s_upper_price) do
    amount * s_lower_price * s_upper_price / (s_upper_price - s_lower_price)
  end

  defp do_get_liquidity_for_amount_1(amount, s_lower_price, s_upper_price) do
    amount / (s_upper_price - s_lower_price)
  end

  defp add_decimals(value, decimals_0, decimals_1) do
    value * :math.pow(10, abs(decimals_0 - decimals_1))
  end

  defp remove_decimals(value, decimals_0, decimals_1) do
    value / :math.pow(10, abs(decimals_0 - decimals_1))
  end

  defp sort_prices(price_a, price_b) when price_a < price_b,
    do: {price_a, price_b}

  defp sort_prices(price_a, price_b), do: {price_b, price_a}

  defp sqrtx96(number) do
    :math.sqrt(number)
  end
end
