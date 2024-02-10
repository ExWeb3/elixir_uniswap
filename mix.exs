defmodule Uniswap.MixProject do
  use Mix.Project

  def project do
    [
      app: :uniswap,
      version: "0.1.0",
      elixir: "~> 1.11",
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
      {:ethers, "~> 0.3.0 or ~> 0.2.0"},
      {:decimal, "~> 2.1", only: :test}
    ]
  end
end
