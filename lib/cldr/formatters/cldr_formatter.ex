defmodule CLDRex.Formatters.CLDRFormatter do
  @moduledoc false
  alias CLDRex.Tokenizers.CLDRTokenizer, as: Tokenizer

  @type date :: Ecto.Date.type | Timex.Date.t
  @type locale :: atom | String.t

  @spec format(date, String.t, {locale, atom}) :: String.t
  def format(date, format_string, context)

  def format(%Ecto.Date{year: year, month: month, day: day}, format_string, context),
    do: do_format({year, month, day}, format_string, context)

  def format(%Timex.Date{year: year, month: month, day: day}, format_string, context),
    do: do_format({year, month, day}, format_string, context)

  def format(_date, _format_string, _context),
    do: raise ArgumentError, "date must be an Ecto.Date or Timex.Date"

  defp do_format({year, month, day}, format_string, context) do
    tokens = Tokenizer.tokenize(format_string)

    Enum.reduce tokens, format_string, fn({token, rule}, fs) ->
      value = do_lookup(rule, context)
      String.replace(fs, token, value, global: false)
    end
  end

  defp do_lookup(rule, {calendar, locale}) when is_list(rule) do
    full_path = Enun.concat([locale, calendar], rule)
  end

  defp do_lookup(rule, {calendar, locale}) do

  end
end
