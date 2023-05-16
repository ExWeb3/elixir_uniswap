defmodule Uniswap.Tick.Math do
  @moduledoc """
  Math library for computing sqrt prices from ticks and vice versa
  """

  import Bitwise

  @max_tick 887_272
  @min_sqrt_ratio 4_295_128_739
  @max_sqrt_ratio 1_461_446_703_485_210_103_287_273_052_203_988_822_378_723_970_342

  @uint256_max Ethers.Types.max({:uint, 256})

  @tick_base 1.0001

  @doc """
  Calculates sqrt(1.0001^tick) * 2^96
  """
  def get_sqrt_ratio_at_tick(tick) do
    abs_tick = abs(tick)

    if abs_tick <= @max_tick do
      ratio =
        if (abs_tick &&& 0x1) != 0,
          do: 0xFFFCB933BD6FAD37AA2D162D1A594001,
          else: 0x100000000000000000000000000000000

      ratio =
        ratio
        |> tick_step(abs_tick, 0x2, 0xFFF97272373D413259A46990580E213A)
        |> tick_step(abs_tick, 0x4, 0xFFF2E50F5F656932EF12357CF3C7FDCC)
        |> tick_step(abs_tick, 0x8, 0xFFE5CACA7E10E4E61C3624EAA0941CD0)
        |> tick_step(abs_tick, 0x10, 0xFFCB9843D60F6159C9DB58835C926644)
        |> tick_step(abs_tick, 0x20, 0xFF973B41FA98C081472E6896DFB254C0)
        |> tick_step(abs_tick, 0x40, 0xFF2EA16466C96A3843EC78B326B52861)
        |> tick_step(abs_tick, 0x80, 0xFE5DEE046A99A2A811C461F1969C3053)
        |> tick_step(abs_tick, 0x100, 0xFCBE86C7900A88AEDCFFC83B479AA3A4)
        |> tick_step(abs_tick, 0x200, 0xF987A7253AC413176F2B074CF7815E54)
        |> tick_step(abs_tick, 0x400, 0xF3392B0822B70005940C7A398E4B70F3)
        |> tick_step(abs_tick, 0x800, 0xE7159475A2C29B7443B29C7FA6E889D9)
        |> tick_step(abs_tick, 0x1000, 0xD097F3BDFD2022B8845AD8F792AA5825)
        |> tick_step(abs_tick, 0x2000, 0xA9F746462D870FDF8A65DC1F90E061E5)
        |> tick_step(abs_tick, 0x4000, 0x70D869A156D2A1B890BB3DF62BAF32F7)
        |> tick_step(abs_tick, 0x8000, 0x31BE135F97D08FD981231505542FCFA6)
        |> tick_step(abs_tick, 0x10000, 0x9AA508B5B7A84E1C677DE54F3E99BC9)
        |> tick_step(abs_tick, 0x20000, 0x5D6AF8DEDB81196699C329225EE604)
        |> tick_step(abs_tick, 0x40000, 0x2216E584F5FA1EA926041BEDFE98)
        |> tick_step(abs_tick, 0x80000, 0x48A170391F7DC42444E8FA2)

      ratio =
        if tick > 0 do
          div(@uint256_max, ratio)
        else
          ratio
        end

      sqrt_price_x96 = (ratio >>> 32) + if(rem(ratio, 1 <<< 32) == 0, do: 0, else: 1)
      {:ok, sqrt_price_x96}
    else
      {:error, :invalid_tick}
    end
  end

  def get_tick_at_sqrt_ratio(sqrt_ratio) do
    if sqrt_ratio >= @min_sqrt_ratio and sqrt_ratio <= @max_sqrt_ratio do
      ratio = :math.pow(sqrt_ratio / :math.pow(2, 96), 2)
      tick = :math.log(ratio) / :math.log(@tick_base)

      {:ok, trunc(tick)}
    else
      {:error, :invalid_sqrt_ratio}
    end
  end

  def tick_base, do: @tick_base

  defp tick_step(ratio, abs_tick, comp, mul) do
    if (abs_tick &&& comp) != 0 do
      (ratio * mul) >>> 128
    else
      ratio
    end
  end
end