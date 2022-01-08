defmodule ExCSSModules.Mixfile do
  use Mix.Project

  @version "0.0.6"

  def project do
    [
      app: :ex_css_modules,
      name: "ExCSSModules",
      source_url: "https://github.com/defactosoftware/ex_css_modules",
      version: @version,
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_per_environment: false,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test],
      dialyzer: [plt_add_apps: [:mix, :ex_unit], check_plt: true]
    ]
  end

  def application do
    []
  end

  defp description do
    """
    CSS Modules for Elixir views.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      name: :ex_css_modules,
      maintainers: ["Jesse Dijkstra"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/defactosoftware/ex_css_modules"}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.14.4", only: :test},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:phoenix_html, "~> 1.0 or ~> 2.0 or ~> 3.0"},
      {:poison, "~> 4.0 or ~> 5.0"},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
