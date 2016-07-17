defmodule CLDRex.Formatters.CLDRDateFormatter do
  @moduledoc false
  alias CLDRex.Main
  alias CLDRex.Directive
  alias CLDRex.Parsers.DateTimeParser

  @type date :: Date.t | {number, number, number}
  @type locale :: atom | String.t

  @spec format(date, String.t, {locale, atom}) :: String.t
  def format(date, format_string, context)

  def format(%Date{} = date, format_string, context),
    do: do_format({date.year, date.month, date.day}, format_string, context)

  def format({_y, _m, _d} = date, format_string, context),
    do: do_format(date, format_string, context)

  def format(_date, _format_string, _context),
    do: raise ArgumentError, "unknown date type"

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

  defp do_lookup(%Directive{type: :literal, token: t}, _date, _context) do
    t
    |> to_string
    |> String.slice(1..-2)
  end

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr}, {year, month, day}, _) when cldr_attr == :numeric do
    case date_part do
      :year  -> year
      :month -> month
      :day   -> day
    end
    |> to_string
  end

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr}, date, {locale, calendar}) when date_part == :week_day do
    weekday_key = compute_day_of_week(date)

    Main.cldr_main_data
    |> get_in([locale, :calendars, calendar])
    |> get_in(cldr_attr)
    |> Map.get(weekday_key)
  end

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr}, {year, month, day}, {locale, calendar}) do
    cldr_data = Main.cldr_main_data
      |> get_in([locale, :calendars, calendar])
      |> get_in(cldr_attr)

    date_data = case date_part do
        :year  -> year
        :month -> month
        :day   -> day
      end |> to_string

    Map.get(cldr_data, date_data)
  end

  defp compute_day_of_week({year, month, day}) do
    sm = shift_month(month)
    {y, _} = year |> to_string |> String.slice(2..3) |> Integer.parse
    {c, _} = year |> to_string |> String.slice(0..1) |> Integer.parse

    {partial, _} = (day + Float.floor(2.6*sm - 0.2) + y + Float.floor(y/4) + Float.floor(c/4) - 2*c)
      |> to_string
      |> Integer.parse

    dw = rem(partial, 7)

    case dw do
      0 -> "sun"
      1 -> "mon"
      2 -> "tue"
      3 -> "wed"
      4 -> "thu"
      5 -> "fri"
      6 -> "sat"
    end
  end

  defp shift_month(month) do
    m = month - 2

    cond do
      m < 0 -> m + 12
      true  -> m
    end
  end
end
