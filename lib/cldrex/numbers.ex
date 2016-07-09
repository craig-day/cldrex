defmodule CLDRex.Numbers do
  @moduledoc """
  Provide number localization including conversion to currency, percentage, and
  decimal values.
  """
  @type locale :: atom | String.t

  @doc """
  Localize the given number into the given locale.
  """
  @spec localize(number, locale) :: String.t
  def localize(number, locale) do

  end

  @doc """
  Convert the given number to the localized currency format.
  """
  @spec to_currency(number, locale) :: String.t
  def to_currency(number, locale) do

  end

  @doc """
  Convert the given number to the localized percentage format.
  """
  @spec to_percent(number, locale) :: String.t
  def to_percent(number, locale) do

  end

  @doc """
  Convert the given number to the localized decimal format.
  """
  @spec to_decimal(number, locale) :: String.t
  def to_decimal(number, locale) do

  end
end
