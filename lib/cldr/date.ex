defmodule CLDRex.Date do
  @moduledoc """

  """
  alias CLDRex.Main
  alias CLDRex.Formatters.CLDRFormatter
  import CLDRex.Utils

  def localize(date, locale, options \\ %{}) do
    locale = normalize_locale(locale)
    fallback = fallback(locale)
    length = get_in(options, [:length]) || :full
    cal = get_in(options, [:calendar]) || :gregorian

    f = get_in(Main.cldr_main_data,
      [locale, :calendar, cal, :date_formats, length])

    if !f || Enum.empty?(f) do
      f = get_in(Main.cldr_main_data,
        [fallback, :calendar, cal, :date_formats, length])
    end

    Timex.format(date, f, CLDRFormatter)
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
