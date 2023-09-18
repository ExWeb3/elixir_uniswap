defmodule Uniswap.MixProject do
  use Mix.Project

  def project do
    [
      app: :uniswap,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ethers, "~> 0.1.0-dev", github: "alisinabh/elixir_ethers"},
      {:decimal, "~> 2.1", only: :test}
    ]
  end
end
