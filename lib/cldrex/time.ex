defmodule CLDRex.Time do
  @moduledoc """
  Provide localization for common date formats.
  """
  import CLDRex.Utils

  alias CLDRex.Main
  alias CLDRex.Formatters.CLDRFormatter

  @type locale :: atom | String.t
  @type date :: Ecto.Time.type | Timex.Time.t | {number, number, number}

  @doc """
  Convert the given date into the corresponding CLDR format.

  Accepted options are:

    - calendar: the calendar to use. default: `:gregorian`
    - length: the date format to use. default: `:full` commonly available:
      - `:full`
      - `:long`
      - `:medium`
      - `:short`

  ## Examples

  ```
  iex> CLDRex.Time.localize({2016, 07, 11}, :en)
  "Monday, July 11, 2016"
  ```

  ```
  iex> CLDRex.Time.localize(Timex.Time.today, :fr)
  "lundi 11 juillet 2016"
  ```

  ```
  iex> CLDRex.Time.localize({2016, 07, 11}, :fr, length: :medium)
  "11 juil. 2016"
  ```

  """
  @spec localize(time, locale, Map.t) :: String.t
  def localize(time, locale, options \\ %{}) do
    locale   = normalize_locale(locale)
    fallback = fallback(locale)
    length   = get_in(options, [:length])   || :full
    cal      = get_in(options, [:calendar]) || :gregorian

    f = get_in(Main.cldr_main_data,
      [locale, :calendar, cal, :time_formats, length])

    if !f, do: f = get_in(Main.cldr_main_data,
      [fallback, :calendar, cal, :time_formats, length])

    CLDRTimeFormatter.format(time, f, {locale, cal})
  end

  @doc """
  Shortcut for `localize/3` when passed the `length: :short` option.

  ## Examples

  ```
  iex> CLDRex.Time.short({2016, 07, 11}, :en)
  "7/11/2016"
  ```

  """
  @spec short(time, locale, atom) :: String.t
  def short(time, locale, calendar \\ :gregorian),
    do: localize(time, locale, %{length: :short, calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: :medium` option.

  ## Examples

  ```
  iex(7)> CLDRex.Time.medium({2016, 07, 11}, :es)
  "11 jul. 2016"
  ```

  """
  @spec medium(time, locale, atom) :: String.t
  def medium(time, locale, calendar \\ :gregorian),
    do: localize(time, locale, %{length: :medium, calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: :long` option.

  ## Examples

  ```
  iex> CLDRex.Time.long({2016, 07, 11}, :fr)
  "11 juillet 2016"
  ```

  """
  @spec long(time, locale, atom) :: String.t
  def long(time, locale, calendar \\ :gregorian),
    do: localize(time, locale, %{length: :long, calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: :full` option.

  ## Examples

  ```
  iex> CLDRex.Time.full({2016, 07, 11}, :de)
  "Montag, 11. Juli 2016"
  ```

  """
  @spec full(time, locale, atom) :: String.t
  def full(time, locale, calendar \\ :gregorian),
    do: localize(time, locale, %{length: :full, calendar: calendar})
end
