defmodule Uniswap do
  @moduledoc """
  Common uniswap functions
  """

  alias Uniswap.Contracts.SwapRouter

  def swap_exact_input_single(
        token_in,
        token_out,
        fee,
        amount_in,
        amount_out_min,
        recipient \\ nil,
        deadline \\ deadline(),
        sqrt_price_limit_x96 \\ 0,
        opts \\ []
      ) do
    SwapRouter.exact_input_single({
      token_in,
      token_out,
      fee,
      recipient,
      deadline,
      amount_in,
      amount_out_min,
      sqrt_price_limit_x96
    })
    |> Ethers.call(opts)
  end

  def deadline(seconds \\ 1800) do
    System.system_time(:second) + seconds
  end
end
