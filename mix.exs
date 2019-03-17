defmodule Budget.MixProject do
  use Mix.Project

  def project do
    [
      app: :budget,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :elixir_google_spreadsheets],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_csv, "~> 0.3"},
      {:elixir_google_spreadsheets, "~> 0.1.9"},
      {:moneyex, "~> 0.1.0"}
    ]
  end
end
