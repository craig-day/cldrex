defmodule CLDRex do
  @moduledoc """
  Provide a list of all supported locales, and a method to check if a given
  locale is supported.
  """
  require CLDRex.Data

  import CLDRex.Utils

  @type locale :: atom | String.t

  @main_data CLDRex.Data.main_data

  @doc """
  A list of all supported locales.
  """
  @spec supported_locales :: list
  def supported_locales do
    Map.keys(@main_data)
  end

  @doc """
  Check if a given locale is supported.
  """
  @spec supported_locale?(locale) :: boolean
  def supported_locale?(locale) do
    l = normalize_locale(locale)

    supported_locales
    |> Enum.map(fn(l) -> to_string(l) |> String.downcase |> String.to_atom end)
    |> Enum.member?(l)
  end
end
