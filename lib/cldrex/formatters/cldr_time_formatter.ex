defmodule CLDRex.Formatters.CLDRTimeFormatter do
  @moduledoc false
  alias CLDRex.Main
  alias CLDRex.Directive
  alias CLDRex.Parsers.DateTimeParser

  @type time :: Time.t | {number, number, number}
  @type locale :: atom | String.t

  @spec format(time, String.t, {locale, atom}) :: String.t
  def format(time, format_string, context)

  def format(%Time{} = time, format_string, context),
    do: do_format({time.hour, time.minute, time.second}, format_string, context)

  def format({_h, _m, _s} = time, format_string, context),
    do: do_format(time, format_string, context)

  def format(_time, _format_string, _context),
    do: raise ArgumentError, "unknown time type"

  defp do_format(time, format_string, context) do
    format_string
    |> DateTimeParser.parse
    |> process_tokens(time, context)
  end

  defp process_tokens(tokens, time, context) do
    Enum.reduce tokens, "", fn (token, result) ->
      result <> process_token(token, time, context)
    end
  end

  defp process_token(%Directive{} = directive, time, context) do
    directive
    |> do_lookup(time, context)
    |> to_string
  end

  defp process_token(directive, _time, _context), do: directive

  defp do_lookup(%Directive{date_part: date_part, cldr_attribute: cldr_attr, token: t}, {hour, minute, second}, _) when cldr_attr == :numeric do
    value = case date_part do
        :hour   -> case t do
          "h"  -> if hour > 12, do: hour - 12, else: hour
          "hh" -> if hour > 12, do: hour - 12, else: hour
          "K"  -> if hour > 12, do: hour - 12, else: hour
          "KK" -> if hour > 12, do: hour - 12, else: hour
          _    -> hour
        end
        :minute -> minute
        :second -> second
      end
      |> to_string

    if String.length(value) < String.length(t) do
      "0" <> value
    else
      value
    end
  end

  defp do_lookup(%Directive{cldr_attribute: cldr_attr}, {hour, _m, _s}, {locale, calendar}) do
    cldr_data = Main.cldr_main_data
      |> get_in([locale, :calendars, calendar])
      |> get_in(cldr_attr)

    period = cond do
      hour < 12 -> "am"
      true      -> "pm"
    end

    Map.get(cldr_data, period)
  end
end
