defmodule CLDRex.Directive do
  @moduledoc false
  alias CLDRex.Directive

  defstruct type: :numeric,
            token: "YYYY",
            date_part: :year,
            cldr_attribute: :year,
            width: 0,
            zero_padding: false

  @type t :: %__MODULE__{}

  @base_types [:year, :year2, :month, :week, :mweek, :day, :yday, :dwday,
    :mjday, :week_day, :hour12, :hour24, :minute, :second, :fsecond,
    :millisecond]

  @cldr_mapped_types [
    month_narrow:  ~w"months format narrow",
    month_wide:    ~w"months format wide",
    month_abrv:    ~w"months format abbreviated",
    smonth_narrow: ~w"months stand-alone narrow",
    smonth_wide:   ~w"months stand-alone wide",
    smonth_abrv:   ~w"months stand-alone abbreviated",
    wd_short:      ~w"days format short",
    wd_narrow:     ~w"days format narrow",
    wd_wide:       ~w"days format wide",
    wd_abrv:       ~w"days format abbreviated",
    lwd_short:     ~w"days format short",
    lwd_narrow:    ~w"days format narrow",
    lwd_wide:      ~w"days format wide",
    lwd_abrv:      ~w"days format abbreviated",
    swd_short:     ~w"days stand-alone short",
    swd_narrow:    ~w"days stand-alone narrow",
    swd_wide:      ~w"days stand-alone wide",
    swd_abrv:      ~w"days stand-alone abbreviated",
    period_narrow: ~w"day_periods format narrow",
    period_wide:   ~w"day_periods format wide",
    period_abrv:   ~w"day_periods format abbreviated",
  ]

  def get(type, opts \\ []) do
    date_part    = Keyword.get(opts, :date_part, :year)
    width        = Keyword.get(opts, :width, 0)
    zero_padding = Keyword.get(opts, :zero_padding, false)
    do_get(type, date_part, width, zero_padding)
  end

  for type <- @base_types do
    defp do_get(unquote(type), date_part, width, zero_padding),
      do: %Directive{type: unquote(type), date_part: date_part, cldr_attribute: :numeric, width: width, zero_padding: zero_padding}
  end

  for {type, cldr_path} <- @cldr_mapped_types do
    defp do_get(unquote(type), date_part, width, zero_padding),
      do: %Directive{type: unquote(type), date_part: date_part, cldr_attribute: unquote(cldr_path), width: width, zero_padding: zero_padding}
  end
end
