defmodule CLDRex.Calendar do
  @moduledoc """
  Provide calendar data for supported languages. This includes months and days
  in various formats and lengths.
  """
  alias CLDRex.Main
  import CLDRex.Utils

  @doc """
  Provide a map of months localized based on desired context and format.

  Accepted options are:

    - calendar: the calendar to use. default: `:gregorian`
    - context: the calendar information you wish to get. default: `:format`. commonly available:
      - `:format`
      - `:"stand-alone"`
    - format: the data format for the months. default: `:wide`. commonly available:
      - `:wide`
      - `:short`
      - `:narrow`
      - `:abbreviated`

  ## Examples

    ```
    iex> CLDRex.Calendar.months(:en)
    %{"1": 'January', "10": 'October', "11": 'November', "12": 'December',
      "2": 'February', "3": 'March', "4": 'April', "5": 'May', "6": 'June',
      "7": 'July', "8": 'August', "9": 'September'}
    ```

    ```
    iex> CLDRex.Calendar.months(:en, context: :"stand-alone", format: :narrow)
    %{"1": 'J', "10": 'O', "11": 'N', "12": 'D', "2": 'F', "3": 'M', "4": 'A',
      "5": 'M', "6": 'J', "7": 'J', "8": 'A', "9": 'S'}
    ```

  """
  @spec months(atom) :: list
  def months(locale, options \\ %{}) do
    locale = normalize_locale(locale)
    fallback = fallback(locale)
    cal = get_in(options, [:calendar]) || :gregorian
    ctxt = get_in(options, [:context]) || :format
    fmt = get_in(options, [:format]) || :wide

    m = get_in(Main.cldr_main_data,
      [locale, :calendar, cal, :months, ctxt, fmt])

    if !m || Enum.empty?(m) do
      m = get_in(Main.cldr_main_data,
        [fallback, :calendar, cal, :months, ctxt, fmt])
    end

    m
  end

  @doc """
  Provide a map of days localized based on desired context and format.

  Accepted options are:

    - calendar: the calendar to use. default: `:gregorian`
    - context: the calendar information you wish to get. default: `:format`. commonly available:
      - `:format`
      - `:"stand-alone"`
    - format: the data format for the days. default: `:wide`. commonly available:
      - `:wide`
      - `:short`
      - `:narrow`
      - `:abbreviated`

  ## Examples

    ```
    iex> CLDRex.Calendar.days(:en)
    %{fri: 'Friday', mon: 'Monday', sat: 'Saturday', sun: 'Sunday', thu: 'Thursday',
      tue: 'Tuesday', wed: 'Wednesday'}
    ```

    ```
    iex> CLDRex.Calendar.days(:en, context: :"stand-alone", format: :narrow)
    %{fri: 'F', mon: 'M', sat: 'S', sun: 'S', thu: 'T', tue: 'T', wed: 'W'}
    ```

  """
  @spec days(atom) :: list
  def days(locale, options \\ %{}) do
    locale = normalize_locale(locale)
    fallback = fallback(locale)
    cal = get_in(options, [:calendar]) || :gregorian
    ctxt = get_in(options, [:context]) || :format
    fmt = get_in(options, [:format]) || :wide

    d = get_in(Main.cldr_main_data,
      [locale, :calendar, cal, :days, ctxt, fmt])

    if !d || Enum.empty?(d) do
      d = get_in(Main.cldr_main_data,
        [fallback, :calendar, cal, :days, ctxt, fmt])
    end

    d
  end
end
