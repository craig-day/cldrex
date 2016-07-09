defmodule CLDRex.Formatters.DateTimeFormatter do
  use Timex.Format.DateTime.Formatter

  alias Timex.DateTime
  alias Timex.Format.FormatError
  alias CLDRex.Tokenizers.Date, as: Tokenizer

  defdelegate tokenize(format_string), to: Tokenizer

  def format!(%DateTime{} = date, format_string) do
    case format(date, format_string) do
      {:ok, result}    -> result
      {:error, reason} -> raise FormatError, message: reason
    end
  end

  def format(%DateTime{} = date, format_string) do
    case tokenize(format_string) do
      {:ok, []} ->
        {:error, "There were no formatting directives in the provided string."}
      {:ok, dirs} when is_list(dirs) ->
        do_format(date, dirs, <<>>)
      {:error, reason} -> {:error, {:format, reason}}
    end
  end

  defp do_format(_date, [], result), do: {:ok, result}
  defp do_format(_date, _, {:error, _} = error), do: error
  # defp do_format(date, [%Directive{type: :literal, value: char} | dirs], result) when is_binary(char) do
  #   do_format(date, dirs, <<result::binary, char::binary>>)
  # end
  # defp do_format(%DateTime{day: day} = date, [%Directive{type: :oday_phonetic} | dirs], result) do
  #   phonetic = Enum.at(@days, day - 1)
  #   do_format(date, dirs, <<result::binary, phonetic::binary>>)
  # end
  # defp do_format(date, [%Directive{type: :date_shift} | dirs], result) do
  #   do_format(date, dirs, <<result::binary, "currently"::binary>>)
  # end
  # defp do_format(date, [%Directive{type: type, modifiers: mods, flags: flags, width: width} | dirs], result) do
  #   case format_token(type, date, mods, flags, width) do
  #     {:error, _} = err -> err
  #     formatted         -> do_format(date, dirs, <<result::binary, formatted::binary>>)
  #   end
  # end
end
