defmodule Uniswap.MixProject do
  use Mix.Project

  @version "0.0.1-dev"
  @source_url "https://github.com/alisinabh/elixir_uniswap"

  def project do
    [
      app: :uniswap,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      source_url: @source_url,
      name: "Uniswap",
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      description:
        "A comprehensive Web3 library for interacting with smart contracts on Ethereum using Elixir.",
      package: package(),
      docs: docs(),
      dialyzer: dialyzer()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      maintainers: ["Alisina Bahadori"],
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      exclude_patterns: ["priv/node_modules"]
    ]
  end

  defp docs do
    source_ref =
      if String.ends_with?(@version, "-dev") do
        "main"
      else
        "v#{@version}"
      end

    [
      main: "readme",
      extras: [
        "README.md": [title: "Introduction"]
      ],
      groups_for_modules: [
        "Math Helpers": [
          ~r/^Uniswap\..*\.Math$/
        ],
        "Uniswap Contracts": [
          ~r/^Uniswap\.Contracts\.(?:(?!EventFilters$).)*$/
        ],
        "Event Filters": [
          ~r/^Uniswap\.Contracts\..*\.EventFilters$/
        ]
      ],
      source_url: @source_url,
      source_ref: source_ref
    ]
  end

  def dialyzer do
    [flags: [:error_handling, :extra_return, :underspecs, :unknown, :unmatched_returns]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:decimal, "~> 2.1", only: :test},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:ethers, "~> 0.3.0 or ~> 0.2.0 or ~> 0.4.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
