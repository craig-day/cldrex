defmodule CLDRex do
  @moduledoc """
  Provide a list of all supported locales, and a method to check if a given
  locale is supported.
  """
  import CLDRex.Utils

  @type locale :: atom | String.t

  @doc """
  A list of all supported locales.
  """
  @spec supported_locales :: list
  def supported_locales do
    Map.keys(CLDRex.Main.cldr_main_data)
  end

  @doc """
  Check if a given locale is supported.
  """
  @spec supported_locale?(locale) :: boolean
  def supported_locale?(locale) do
    l = normalize_locale(locale)
    Enum.member?(supported_locales, l)
  end
end
