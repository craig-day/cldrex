defmodule CLDRex.Formatters.CLDRFormatter do
  @moduledoc false
  alias CLDRex.Main
  alias CLDRex.Parsers.DateTimeParser, as: Tokenizer

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
    # tokens = Tokenizer.tokenize(format_string)
    format_string
    |> Tokenizer.tokenize
    |> lookup_and_replace


    # Enum.reduce tokens, format_string, fn({token, rule, property}, fs) ->
    #   do_lookup(rule, context)
    #     |> do_replacement(date, format_string, {token, property})
    #     |> inspect |> IO.puts
    # end
  end

  defp lookup_and_replace(tokens, fs, rule, context) when tokens == []

  defp lookup_and_replace(tokens, fs, rule, context) do
    {locale, calendar} = context
    do_lookup
  end

  defp do_lookup(rule, {locale, calendar}) when is_list(rule) do
    Main.cldr_main_data
    |> get_in([locale, :calendar, calendar])
    |> get_in(rule)
  end

  defp do_lookup(rule, {calendar, locale}) do

  end

  defp do_replacement(cldr_data, date, format_string, {token, date_attr}) do
    data = date
      |> Map.get(date_attr)
      |> to_string

    String.replace(format_string, token, data, global: false)
  end
end
