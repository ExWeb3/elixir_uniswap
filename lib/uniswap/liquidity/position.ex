defmodule Uniswap.Liquidity.Position do
  @moduledoc """
  Uniswap Position info Struct
  """

  defstruct [
    :id,
    :nonce,
    :operator,
    :token0,
    :token1,
    :fee,
    :tick_lower,
    :tick_upper,
    :liquidity,
    :fee_growth_inside_0_last_x_128,
    :fee_growth_inside_1_last_x_128,
    :tokens_owed_0,
    :tokens_owed_1
  ]

  def parse({id, params}) do
    position = parse(params)
    %{position | id: id}
  end

  def parse([
        nonce,
        operator,
        token0,
        token1,
        fee,
        tickLower,
        tickUpper,
        liquidity,
        feeGrowthInside0LastX128,
        feeGrowthInside1LastX128,
        tokensOwed0,
        tokensOwed1
      ]) do
    %__MODULE__{
      nonce: nonce,
      operator: operator,
      token0: token0,
      token1: token1,
      fee: fee,
      tick_lower: tickLower,
      tick_upper: tickUpper,
      liquidity: liquidity,
      fee_growth_inside_0_last_x_128: feeGrowthInside0LastX128,
      fee_growth_inside_1_last_x_128: feeGrowthInside1LastX128,
      tokens_owed_0: tokensOwed0,
      tokens_owed_1: tokensOwed1
    }
  end
end
