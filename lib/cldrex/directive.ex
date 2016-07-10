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
    month_narrow:  [:months, :format, :narrow],
    month_wide:    [:months, :format, :wide],
    month_abrv:    [:months, :format, :abbreviated],
    smonth_narrow: [:months, :"stand-alone", :narrow],
    smonth_wide:   [:months, :"stand-alone", :wide],
    smonth_abrv:   [:months, :"stand-alone", :abbreviated],
    wd_short:      [:days, :format, :short],
    wd_narrow:     [:days, :format, :narrow],
    wd_wide:       [:days, :format, :wide],
    wd_abrv:       [:days, :format, :abbreviated],
    lwd_short:     [:days, :format, :short],
    lwd_narrow:    [:days, :format, :narrow],
    lwd_wide:      [:days, :format, :wide],
    lwd_abrv:      [:days, :format, :abbreviated],
    swd_short:     [:days, :"stand-alone", :short],
    swd_narrow:    [:days, :"stand-alone", :narrow],
    swd_wide:      [:days, :"stand-alone", :wide],
    swd_abrv:      [:days, :"stand-alone", :abbreviated],
    period_narrow: [:day_periods, :format, :narrow],
    period_wide:   [:day_periods, :format, :wide],
    period_abrv:   [:day_periods, :format, :abbreviated],
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
