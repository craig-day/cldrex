defmodule CLDRex.Parsers.JSONParser do
  @moduledoc false

  @data_path Path.expand("../../../priv/data/common/main_json", __DIR__)

  def parse do
    @data_path
    |> File.ls!
    |> process_files
  end

  defp process_files(files) do
    Enum.reduce files, %{}, fn (f, acc) ->
      Map.merge(acc, process_file(f))
    end
  end

  defp process_file(file) do
    IO.puts "Processing #{inspect(file)}"

    locale = build_locale_from_file(file)

    data = @data_path
      |> Path.join(file)
      |> File.read!
      |> Poison.decode!

    Map.put(%{}, locale, %{
      calendars: get_in(data, ~w"dates calendars"),
      languages: get_in(data, ~w"localeDisplayNames languages"),
      numbers:   extract_numbers_data(data)
    })
  end

  defp build_locale_from_file(file) do
    file
    |> String.slice(0..-6)
    |> String.to_atom
  end

  defp extract_numbers_data(data) do
    number_system = get_in(data, ~w"numbers defaultNumberingSystem")

    %{
      percent_format: get_in(data, ~w"numers percentFormats percentFormatLength percentFormat pattern"),
      default_number_system: number_system,
      currencies: extract_currencies(data),
      decimal_formats: get_in(data, ~w"numbers decimalFormats"),
      symbols: get_in(data, ["numbers", "symbols-numberSystem-#{number_system}"])
    }
  end

  defp extract_currencies(data) do
    get_in(data, ~w"numbers currencies") # TODO refine this data
  end
end
