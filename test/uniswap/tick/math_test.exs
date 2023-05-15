defmodule Uniswap.Tick.MathTest do
  use ExUnit.Case

  alias Uniswap.Tick

  @sample_ticks [
    50,
    100,
    250,
    500,
    1_000,
    2_500,
    3_000,
    4_000,
    5_000,
    50_000,
    150_000,
    250_000,
    500_000,
    738_203
  ]

  describe "get_sqrt_ratio_at_tick" do
    test "tick is at most diff of 1/100th of a bips" do
      for tick <- @sample_ticks do
        expected_result = sqrt_ratio(tick)

        {:ok, result} = Tick.Math.get_sqrt_ratio_at_tick(tick)
        abs_diff = abs(result - expected_result)
        assert abs_diff / expected_result < 0.000001
      end
    end

    test "returns error with invalid ticks" do
      min = -887_272
      max = -min

      assert {:ok, _} = Tick.Math.get_sqrt_ratio_at_tick(min)
      assert {:ok, _} = Tick.Math.get_sqrt_ratio_at_tick(max)

      assert {:error, :invalid_tick} = Tick.Math.get_sqrt_ratio_at_tick(min - 1)
      assert {:error, :invalid_tick} = Tick.Math.get_sqrt_ratio_at_tick(max + 1)
    end
  end

  describe "get_tick_at_sqrt_ratio" do
    test "correct tick for a given sqrt price" do
      for expected_tick <- @sample_ticks do
        sqrt_ratio = sqrt_ratio(expected_tick)

        {:ok, tick} = Tick.Math.get_tick_at_sqrt_ratio(sqrt_ratio)
        assert tick === expected_tick
      end
    end

    test "returns error with invalid sqrt ratio" do
      min = 4_295_128_739
      max = 1_461_446_703_485_210_103_287_273_052_203_988_822_378_723_970_342

      {:ok, _} = Tick.Math.get_tick_at_sqrt_ratio(min)
      {:ok, _} = Tick.Math.get_tick_at_sqrt_ratio(max)

      {:error, :invalid_sqrt_ratio} = Tick.Math.get_tick_at_sqrt_ratio(min - 1)
      {:error, :invalid_sqrt_ratio} = Tick.Math.get_tick_at_sqrt_ratio(max + 1)
    end
  end

  defp sqrt_ratio(tick) do
    pow(Decimal.from_float(Tick.Math.tick_base()), tick)
    |> Decimal.sqrt()
    |> Decimal.mult(pow(Decimal.new(2), 96))
    |> Decimal.to_integer()
  end

  defp(pow(n, p, acc \\ Decimal.new(1)))

  defp pow(n, p, acc) when p < 0 do
    Decimal.new(1) |> Decimal.div(pow(n, -p, acc))
  end

  defp pow(_n, 0, acc) do
    acc
  end

  defp pow(n, p, acc) do
    pow(n, p - 1, Decimal.mult(acc, n))
  end
end
