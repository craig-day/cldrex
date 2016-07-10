defmodule CLDRex.Formatters.CLDRFormatter do
  @moduledoc false
  alias CLDRex.Main
  alias CLDRex.Directive
  alias CLDRex.Parsers.DateTimeParser

  @type date :: Ecto.Date.type | Timex.Date.t
  @type locale :: atom | String.t

  @spec format(date, String.t, {locale, atom}) :: String.t
  def format(date, format_string, context)

  def format(%Ecto.Date{year: y, month: m, day: d}, format_string, context),
    do: do_format(%{year: y, month: m, day: d}, format_string, context)

  def format(%Timex.Date{year: y, month: m, day: d}, format_string, context),
    do: do_format(%{year: y, month: m, day: d}, format_string, context)

  def format(_date, _format_string, _context),
    do: raise ArgumentError, "date must be a Ecto.Date or Timex.Date"

  defp do_format(date, format_string, context) do
    format_string
    |> DateTimeParser.parse
    |> process_tokens(date, context)
  end

  defp process_tokens(tokens, date, context) do
    Enum.reduce tokens, "", fn (token, result) ->
      result <> process_token(token, date, context)
    end
  end

  defp process_token(%Directive{} = directive, date, context) do
    directive
    |> do_lookup(date, context)
    |> to_string
  end

  defp process_token(directive, _date, _context), do: directive

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr}, date, _) when cldr_attr == :numeric do
    date
    |> Map.get(date_part)
    |> to_string
  end

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr} = directive, date, {locale, calendar}) do
    cldr_data = Main.cldr_main_data
      |> get_in([locale, :calendar, calendar])
      |> get_in(cldr_attr)

    date_data = date
    |> Map.get(date_part)
    |> to_string
    |> String.to_atom

    Map.get(cldr_data, date_data)
  end
end
