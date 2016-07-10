defmodule CLDRex.Mixfile do
  use Mix.Project

  # Don't forget to update the README
  @version "0.0.2"

  def project do
    [app: :cldrex,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),

     # Hex
     description: description(),
     package: package(),

     # Docs
     name: "CLDRex",
     source_url: "https://github.com/zendesk/cldrex",
     homepage_url: "https://github.com/zendesk/cldrex",
     docs: [main: "CLDRex", source_ref: "v#{@version}", extras: ["README.md"]]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:sweet_xml, "~> 0.6"},
     {:timex, "~> 2.2"},
     {:ecto, "~> 2.0"},
     {:ex_doc, "~> 0.12", only: [:dev, :docs]}]
  end

  defp description do
    """
    Provide common localization data and formatting attributes from the CLDR.
    """
  end

  defp package do
    [name: :cldrex,
     files: ["priv", "lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Craig Day"],
     licenses: ["GNU GPLv3"],
     links: %{github: "https://github.com/zendesk/cldrex"}]
  end
end
