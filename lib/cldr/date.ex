defmodule CLDRex.Date do
  @moduledoc """

  """
  import CLDRex.Utils

  alias CLDRex.Main
  alias CLDRex.Formatters.CLDRFormatter

  @type locale :: atom | String.t
  @type date :: Ecto.Date.type | Timex.Date.t


  @spec localize(date, locale, Map.t) :: String.t
  def localize(date, locale, options \\ %{}) do
    locale = normalize_locale(locale)
    fallback = fallback(locale)
    length = get_in(options, [:length]) || :full
    cal = get_in(options, [:calendar]) || :gregorian

    f = get_in(Main.cldr_main_data,
      [locale, :calendar, cal, :date_formats, length])

    if !f, do: f = get_in(Main.cldr_main_data,
      [fallback, :calendar, cal, :date_formats, length])

    CLDRFormatter.format(date, f, {locale, cal})
  end

  def short(date, locale, calendar \\ :gregorian),
    do: localize(date, locale, %{length: :short, calendar: calendar})

  def medium(date, locale, calendar \\ :gregorian),
    do: localize(date, locale, %{length: :medium, calendar: calendar})

  def long(date, locale, calendar \\ :gregorian),
    do: localize(date, locale, %{length: :long, calendar: calendar})

  def full(date, locale, calendar \\ :gregorian),
    do: localize(date, locale, %{length: :full, calendar: calendar})
end
