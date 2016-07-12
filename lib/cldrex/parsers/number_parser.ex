defmodule CLDRex.Parsers.NumberParser do
  @moduledoc false
  alias CLDRex.Main

  def parse(format_string, locale) do
    format_string = to_string(format_string)
    [whole_part, fractional_part] = extract_base_parts(format_string, locale)
    [grouping, first_grouping] = extract_groupings(whole_part, locale)

    %{grouping: grouping, first_grouping: first_grouping, fractional_part: fractional_part}
  end

  defp extract_base_parts(format_string, locale),
    do: String.split(format_string, ".", parts: 2)

  defp extract_groupings(format_string, locale),
    do: String.split(format_string, ",", parts: 2)
end
