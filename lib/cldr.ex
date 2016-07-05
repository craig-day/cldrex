defmodule CLDR do
  @moduledoc """

  """
  require CLDR.Data

  import CLDR.Utils

  alias CLDR.Languages

  @main_data CLDR.Data.main_data

  @spec supported_locales :: list
  def supported_locales do
    Map.keys(@main_data)
  end

  @spec supported_locale?(atom) :: boolean
  def supported_locale?(locale) do
    l = normalize_locale(locale)

    supported_locales
    |> Enum.map(fn(l) -> to_string(l) |> String.downcase |> String.to_atom end)
    |> Enum.member?(l)
  end
end
