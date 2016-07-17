defmodule CLDRex.Time do
  @moduledoc """
  Provide time localization for common time formats.
  """
  import CLDRex.Utils

  alias CLDRex.Main
  alias CLDRex.Formatters.CLDRTimeFormatter

  @type locale :: atom | String.t
  @type time :: Time.t | {number, number, number}

  @doc """
  Convert the given time into the corresponding CLDR format.

  Accepted options are:

    - calendar: the calendar to use. default: `gregorian`
    - length: the time format to use. commonly available:
      - `full`
      - `long`
      - `medium`
      - `short`

  ## Examples

  ```
  iex> {date, time} = :calendar.universal_time
  {{2016, 7, 17}, {9, 38, 43}}

  iex> CLDRex.Time.localize(time, :en)
  "9:38:43 PM"
  ```

  ```
  iex> CLDRex.Time.localize({1, 2, 3}, :en)
  "1:02:03 AM"
  ```

  ```
  iex> CLDRex.Time.localize({1, 2, 3}, :es)
  "1:02:03"
  ```

  ```
  iex> CLDRex.Time.localize({17, 2, 3}, :en)
  "5:02:03 PM"
  ```

  """
  @spec localize(time, locale, Keyword.t) :: String.t
  def localize(time, locale, options \\ []) do
    locale   = normalize_locale(locale)
    cal      = get_in(options, [:calendar]) || default_calendar(locale)
    length   = get_in(options, [:length])   || default_time_format(locale, cal)

    f = get_in(Main.cldr_main_data,
      [locale, :calendars, cal, "timeFormats", length, "timeFormat", "pattern"])

    CLDRTimeFormatter.format(time, f, {locale, cal})
  end

  @doc """
  Shortcut for `localize/3` when passed the `length: "short"` option.

  ## Examples

  ```
  iex> CLDRex.Time.short({17, 2, 3}, :en)
  "5:02 PM"
  ```

  """
  @spec short(time, locale, atom) :: String.t
  def short(time, locale, calendar \\ nil),
    do: localize(time, locale, %{length: "short", calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: "medium"` option.

  ## Examples

  ```
  iex> CLDRex.Time.medium({17, 2, 3}, :en)
  "5:02:03 PM"
  ```

  """
  @spec medium(time, locale, atom) :: String.t
  def medium(time, locale, calendar \\ nil),
    do: localize(time, locale, %{length: "medium", calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: "long"` option.

  ## Examples

  ```
  iex> CLDRex.Time.long({17, 2, 3}, :en)
  "5:02:03 PM z"
  ```

  """
  @spec long(time, locale, atom) :: String.t
  def long(time, locale, calendar \\ nil),
    do: localize(time, locale, %{length: "long", calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: "full"` option.

  ## Examples

  ```
  iex> CLDRex.Time.long({17, 2, 3}, :en)
  "5:02:03 PM zzzz"
  ```

  """
  @spec full(time, locale, atom) :: String.t
  def full(time, locale, calendar \\ nil),
    do: localize(time, locale, %{length: "full", calendar: calendar})
end
