defmodule CLDRex.Formatters.NumberFormatter do
  @moduledoc false
  import CLDRex.Utils, only: [default_decimal_format: 1]

  alias CLDRex.Main
  alias CLDRex.Parsers.NumberParser

  @type locale :: atom | String.t

  def format(number, format, locale, options \\ %{}) do
    format
    |> NumberParser.parse(locale)
    |> process_tokens(number, locale, options)
  end

  defp process_tokens(%{first_grouping: fg}, number, locale, %{precision: precision}) do
    {integer, remainder} = number
    |> to_string
    |> Integer.parse

    grouping_size = String.length(fg)
    whole_part    = parse_whole_part(integer, grouping_size, locale)
    precision     = normalize_precision(precision, remainder)
    remainder     = normalize_remainder(remainder)

    cond do
      precision > 15 ->
        r = String.slice(remainder, 2..-1)
        Enum.join([whole_part, decimal(locale), r])
      precision > 0 ->
        r = remainder
          |> Float.parse
          |> elem(0)
          |> Float.round(precision)
          |> to_string
          |> String.slice(2..-1)

        Enum.join([whole_part, decimal(locale), r])
      true ->
        whole_part
    end
  end

  defp parse_whole_part(integer, group_size, locale) do
    integer
    |> Integer.digits
    |> Enum.reverse
    |> Enum.chunk(group_size, group_size, [])
    |> normalize_group
    |> Enum.reverse
    |> Enum.join(group(locale))
  end

  defp normalize_group(group) do
    Enum.reduce group, [], fn (g, acc) ->
      part = g
        |> Enum.reverse
        |> Enum.join
      Enum.concat(acc, [part])
    end
  end

  defp normalize_precision(precision, remainder) do
    case precision do
      nil -> String.length(remainder) - 1
      _   -> precision
    end
  end

  defp normalize_remainder(remainder) do
    case remainder do
      nil -> "0.0"
      ""  -> "0.0"
      _   -> "0" <> remainder
    end
  end

  defp group(locale),
    do: get_in(Main.cldr_main_data, [locale, :numbers, :symbols, "group"])

  defp decimal(locale),
    do: get_in(Main.cldr_main_data, [locale, :numbers, :symbols, "decimal"])
end
