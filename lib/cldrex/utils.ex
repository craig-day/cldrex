defmodule CLDRex.Utils do
  @moduledoc false

  @doc false
  def normalize_locale(locale) when is_atom(locale), do: locale

  @doc false
  def normalize_locale(locale) when is_binary(locale) do
    locale
    |> String.replace("-", "_")
    |> String.downcase
    |> String.to_atom
  end

  @doc false
  def normalize_locale(locale) do
    locale
    |> to_string
    |> normalize_locale
  end

  @doc false
  def fallback(locale) do
    locale
    |> normalize_locale
    |> to_string
    |> String.split("_")
    |> Enum.at(0, "en")
    |> normalize_locale
  end

  @doc false
  def supported?(locale) do
    l = normalize_locale(locale)
    f = fallback(locale)

    CLDRex.supported_locale?(l) || CLDRex.supported_locale?(f)
  end

  @doc false
  def default_calendar(locale) do
    l = normalize_locale(locale)

    cal = CLDRex.Main.cldr_main_data
      |> get_in([l, :calendars, "default"])
      |> to_string

    cal || "gregorian"
  end

  @doc false
  def default_date_format(locale, calendar) do
    l = normalize_locale(locale)

    CLDRex.Main.cldr_main_data
    |> get_in([l, :calendars, calendar, "dateFormats", "default"])
    |> to_string
  end

  @doc false
  def default_time_format(locale, calendar) do
    l = normalize_locale(locale)

    CLDRex.Main.cldr_main_data
    |> get_in([l, :calendars, calendar, "timeFormats", "default"])
    |> to_string
  end

  @doc false
  def default_decimal_format(locale) do
    l = normalize_locale(locale)

    CLDRex.Main.cldr_main_data
    |> get_in([l, :numbers, :decimal_formats, "standard", "decimalFormat", "pattern"])
    |> to_string
  end

  @doc false
  def default_number_system(locale) do
    l = normalize_locale(locale)

    CLDRex.Main.cldr_main_data
    |> get_in([l, :numbers, :default_number_system])
    |> to_string
  end
end
