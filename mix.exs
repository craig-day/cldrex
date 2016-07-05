defmodule CLDRex.Mixfile do
  use Mix.Project

  def project do
    [app: :cldrex,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     docs: [extras: ["README.md"]]]
  end

  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [{:sweet_xml, ">= 0.0.0"},
     {:ex_doc, "~> 0.12", only: :dev}]
  end
end
