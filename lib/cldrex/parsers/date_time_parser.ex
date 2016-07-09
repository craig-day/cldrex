defmodule CLDRex.Parsers.DateTimeParser do
  @moduledoc false
  alias CLDRex.Main

  @rules [
    # Era
    {~r/G{5}/,   [:eras, :era_narrow], :era},
    {~r/G{4}/,   [:eras, :era_names], :era},
    {~r/G{1-3}/, [:eras, :era_abbr], :era},
    # Year
    {~r/[yur]{3,}/i, :year_padded, :year},
    {~r/[yur]{2}/i,  :year2, :year},
    {~r/[yur]/i,     :year_no_padding, :year},
    # Quarter
    {~r/Q{5}/,   [:quarters, :format, :narrow], :quarter},
    {~r/Q{4}/,   [:quarters, :format, :wide], :quarter},
    {~r/Q{3}/,   [:quarters, :format, :abbreviated], :quarter},
    {~r/Q{1,2}/, [:quarters, :format, :numeric], :quarter},
    {~r/q{5}/,   [:quarters, :"stand-alone", :narrow], :quarter},
    {~r/q{4}/,   [:quarters, :"stand-alone", :wide], :quarter},
    {~r/q{3}/,   [:quarters, :"stand-alone", :abbreviated], :quarter},
    {~r/q{1,2}/, [:quarters, :"stand-alone", :numeric], :quarter},
    # Month
    {~r/M{5}/,   [:months, :format, :narrow], :month},
    {~r/M{4}/,   [:months, :format, :wide], :month},
    {~r/M{3}/,   [:months, :format, :abbreviated], :month},
    {~r/M{1,2}/, [:months, :format, :numeric], :month},
    {~r/L{5}/,   [:months, :"stand-alone", :narrow], :month},
    {~r/L{4}/,   [:months, :"stand-alone", :wide], :month},
    {~r/L{3}/,   [:months, :"stand-alone", :abbreviated], :month},
    {~r/L{1,2}/, [:months, :"stand-alone", :numeric], :month},
    # Week
    {~r/w{1,2}/, :week_of_year, :week},
    {~r/W/,      :week_of_month, :week},
    # Day
    {~r/d{1,2}/, :day_of_month, :day},
    {~r/D{1,3}/, :day_of_year, :day},
    {~r/F/,      :day_of_week_in_month, :day},
    {~r/g{1,}/,  :modified_julian_day, :day},
    # Week Day
    {~r/E{6}/,   [:days, :format, :short], :week_day},
    {~r/E{5}/,   [:days, :format, :narrow], :week_day},
    {~r/E{4}/,   [:days, :format, :wide], :week_day},
    {~r/E{1,3}/, [:days, :format, :abbreviated], :week_day},
    {~r/e{6}/,   [:days, :format, :short], :week_day},
    {~r/e{5}/,   [:days, :format, :narrow], :week_day},
    {~r/e{4}/,   [:days, :format, :wide], :week_day},
    {~r/e{3}/,   [:days, :format, :abbreviated], :week_day},
    {~r/e{1,2}/, [:days, :format, :numeric], :week_day},
    {~r/c{6}/,   [:days, :"stand-alone", :short], :week_day},
    {~r/c{5}/,   [:days, :"stand-alone", :narrow], :week_day},
    {~r/c{4}/,   [:days, :"stand-alone", :wide], :week_day},
    {~r/c{3}/,   [:days, :"stand-alone", :abbreviated], :week_day},
    {~r/c/,      [:days, :"stand-alone", :numeric], :week_day},
    # Period
    {~r/a{5}/,    [:day_periods, :format, :narrow], :period},
    {~r/a{4}/,    [:day_periods, :format, :wide], :period},
    {~r/a{1,3}/,  [:day_periods, :format, :abbreviated], :period},
    {~r/b{5}/i,   [:day_periods, :format, :narrow], :period},
    {~r/b{4}/i,   [:day_periods, :format, :wide], :period},
    {~r/b{1,3}/i, [:day_periods, :format, :abbreviated], :period},
    # Hour
    {~r/h{1,2}/, :hour12, :hour},
    {~r/H{1,2}/, :hour24_zero, :hour},
    {~r/K{1,2}/, :hour12_zero, :hour},
    {~r/k{1,2}/, :hour24, :hour},
    # Minute
    {~r/m{1,2}/, :minute, :minute},
    # Second
    {~r/s{1,2}/, :second, :second},
    {~r/S{1,}/,  :fractional_second, :second},
    {~r/A{1,}/,  :millisecond, :second}
    # Zone
      # TODO
  ]


  def tokenize(format_string), do: apply_rules(@rules, format_string, [])

  defp apply_rules(rules, format_string, tokens) when rules == [], do: tokens
  defp apply_rules(rules, format_string, tokens) do
    {rule, remaining_rules} = Enum.split(rules, 1)
    {pattern, cldr_key, property} = Enum.at(rule, 0)

    run = Regex.run(pattern, format_string)

    match = if run, do: Enum.at(run, 0)

    {new_tokens, remaining_string} = case match do
      nil -> {tokens, format_string}
      _   -> {Enum.concat(tokens, [{match, cldr_key, property}]),
        String.replace(format_string, match, "*", global: false)}
    end

    apply_rules(remaining_rules, remaining_string, new_tokens)
  end
end
