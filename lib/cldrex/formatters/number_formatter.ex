defmodule CLDRex.Formatters.NumberFormatter do
  @moduledoc false
  import CLDRex.Utils

  alias CLDRex.Main
  alias CLDRex.Parsers.NumberParser

  @type locale :: atom | String.t

  def format(number, format, locale) do
    format
    |> NumberParser.parse(locale)
    |> process_tokens(number, locale)
  end

  defp process_tokens(%{grouping: _g, first_grouping: fg, fractional_part: _fp}, number, locale) do
    {integer, remainder} = number
    |> to_string
    |> Integer.parse

    grouping_size = String.length(fg)

    integer
    |> Integer.digits
    |> Enum.chunk(grouping_size)
    |> Enum.reduce([], fn (g, acc) -> Enum.concat(acc, [Enum.join(g)]) end)
    |> Enum.join(group(locale))
  end

  defp group(locale) do
    Main.cldr_main_data
    |> get_in([locale, :numbers, :symbols, :group])
  end
end
