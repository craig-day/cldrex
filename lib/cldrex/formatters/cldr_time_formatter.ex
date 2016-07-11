defmodule CLDRex.Formatters.CLDRTimeFormatter do
  @moduledoc false
  alias CLDRex.Main
  alias CLDRex.Directive
  alias CLDRex.Parsers.DateTimeParser

  @type time :: Ecto.Time.type | Timex.Time.t | {number, number, number}
  @type locale :: atom | String.t

  @spec format(time, String.t, {locale, atom}) :: String.t
  def format(time, format_string, context)

  def format(%Timex.Time{} = time, format_string, context),
    do: do_format(time, format_string, context)

  def format(%Ecto.Time{} = time, format_string, context) do
    {:ok, d} = Ecto.dump(time)
    Timex.Time.from(d)
    |> do_format(format_string, context)
  end

  def format(_time, _format_string, _context),
    do: raise ArgumentError, "unknown time type"

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

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr}, %Timex.Time{year: y, month: m, day: d} = date, _) when cldr_attr == :numeric do
    case date_part do
      :year  -> y
      :month -> m
      :day   -> d
    end
    |> to_string
  end

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr}, date, {locale, calendar}) when date_part == :week_day do
    weekday_key = date
      |> Timex.weekday
      |> Timex.day_shortname
      |> String.downcase
      |> String.to_atom

    Main.cldr_main_data
    |> get_in([locale, :calendar, calendar])
    |> get_in(cldr_attr)
    |> Map.get(weekday_key)
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
