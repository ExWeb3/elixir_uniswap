defmodule Uniswap.Contracts.Utils do
  @moduledoc false

  def abi_path(package, relative_path) do
    :code.priv_dir(:uniswap)
    |> to_string()
    |> Path.join("abis")
    |> Path.join(package)
    |> Path.join(relative_path)
  end
end
