defmodule CLDRex.Numbers do
  @moduledoc false
  # @moduledoc """
  # Provide number localization including conversion to currency, percentage, and
  # decimal values.
  # """
  import CLDRex.Utils

  alias CLDRex.Main
  alias CLDRex.Formatters.NumberFormatter

  @type locale :: atom | String.t

  @doc """
  Localize the given number.

  Accepted options are:

    - precision: the floating point precision. default: nil - it will not round
        the fractional part of the number.  Valid options are 0..15.


  ## Examples

  ```
  iex> CLDRex.Numbers.localize(12345, :en)
  "12,345"
  ```

  ```
  iex> CLDRex.Numbers.localize(12345.789, :en)
  "12,345.789"
  ```

  ```
  iex> CLDRex.Numbers.localize(12345.789, :en, precision: 2)
  "12,345.79"
  ```

  """
  @spec localize(number, locale, Map.t) :: String.t
  def localize(number, locale, options \\ %{}) do
    locale    = normalize_locale(locale)
    fallback  = fallback(locale)
    precision = get_in(options, [:precision])

    pattern = get_in(Main.cldr_main_data,
      [locale, :numbers, :decimal_pattern])

    if !pattern, do: pattern = get_in(Main.cldr_main_data,
      [locale, :numbers, :decimal_pattern])

    NumberFormatter.format(number, pattern, locale, %{precision: precision})
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
