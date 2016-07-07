defmodule CLDRex.Tokenizers.CLDRTokenizer do
  @moduledoc false
  alias CLDRex.Main

  @rules [
    # Era
    {~r/G{5}/,   [:eras, :era_narrow]},
    {~r/G{4}/,   [:eras, :era_names]},
    {~r/G{1-3}/, [:eras, :era_abbr]},
    # Year
    {~r/[yur]{3,}/i, :year_padded},
    {~r/[yur]{2}/i,  :year2},
    {~r/[yur]/i,     :year_no_padding},
    # Quarter
    {~r/Q{5}/,   [:quarters, :format, :narrow]},
    {~r/Q{4}/,   [:quarters, :format, :wide]},
    {~r/Q{3}/,   [:quarters, :format, :abbreviated]},
    {~r/Q{1,2}/, [:quarters, :format, :numeric]},
    {~r/q{5}/,   [:quarters, :"stand-alone", :narrow]},
    {~r/q{4}/,   [:quarters, :"stand-alone", :wide]},
    {~r/q{3}/,   [:quarters, :"stand-alone", :abbreviated]},
    {~r/q{1,2}/, [:quarters, :"stand-alone", :numeric]},
    # Month
    {~r/M{5}/,   [:months, :format, :narrow]},
    {~r/M{4}/,   [:months, :format, :wide]},
    {~r/M{3}/,   [:months, :format, :abbreviated]},
    {~r/M{1,2}/, [:months, :format, :numeric]},
    {~r/L{5}/,   [:months, :"stand-alone", :narrow]},
    {~r/L{4}/,   [:months, :"stand-alone", :wide]},
    {~r/L{3}/,   [:months, :"stand-alone", :abbreviated]},
    {~r/L{1,2}/, [:months, :"stand-alone", :numeric]},
    # Week
    {~r/w{1,2}/, :week_of_year},
    {~r/W/,      :week_of_month},
    # Day
    {~r/d{1,2}/, :day_of_month},
    {~r/D{1,3}/, :day_of_year},
    {~r/F/,      :day_of_week_in_month},
    {~r/g{1,}/,  :modified_julian_day},
    # Week Day
    {~r/E{6}/,   [:days, :format, :short]},
    {~r/E{5}/,   [:days, :format, :narrow]},
    {~r/E{4}/,   [:days, :format, :wide]},
    {~r/E{1,3}/, [:days, :format, :abbreviated]},
    {~r/e{6}/,   [:days, :format, :short]},
    {~r/e{5}/,   [:days, :format, :narrow]},
    {~r/e{4}/,   [:days, :format, :wide]},
    {~r/e{3}/,   [:days, :format, :abbreviated]},
    {~r/e{1,2}/, [:days, :format, :numeric]},
    {~r/c{6}/,   [:days, :"stand-alone", :short]},
    {~r/c{5}/,   [:days, :"stand-alone", :narrow]},
    {~r/c{4}/,   [:days, :"stand-alone", :wide]},
    {~r/c{3}/,   [:days, :"stand-alone", :abbreviated]},
    {~r/c/,      [:days, :"stand-alone", :numeric]},
    # Period
    {~r/a{5}/,    [:day_periods, :format, :narrow]},
    {~r/a{4}/,    [:day_periods, :format, :wide]},
    {~r/a{1,3}/,  [:day_periods, :format, :abbreviated]},
    {~r/b{5}/i,   [:day_periods, :format, :narrow]},
    {~r/b{4}/i,   [:day_periods, :format, :wide]},
    {~r/b{1,3}/i, [:day_periods, :format, :abbreviated]},
    # Hour
    {~r/h{1,2}/, :hour12},
    {~r/H{1,2}/, :hour24_zero},
    {~r/K{1,2}/, :hour12_zero},
    {~r/k{1,2}/, :hour24},
    # Minute
    {~r/m{1,2}/, :minute},
    # Second
    {~r/s{1,2}/, :second},
    {~r/S{1,}/,  :fractional_second},
    {~r/A{1,}/,  :milliseconds}
    # Zone
      # TODO
  ]


  def tokenize(format_string), do: apply_rules(@rules, format_string, [])

  defp apply_rules(rules, format_string, tokens) when rules == [], do: tokens
  defp apply_rules(rules, format_string, tokens) do
    {rule, remaining_rules} = Enum.split(rules, 1)
    {pattern, cldr_key} = Enum.at(rule, 0)

    run = Regex.run(pattern, format_string)

    match = if run, do: Enum.at(run, 0)

    {new_tokens, remaining_string} = case match do
      nil -> {tokens, format_string}
      _   -> {Enum.concat(tokens, [{match, cldr_key}]),
        String.replace(format_string, match, "*", global: false)}
    end

    apply_rules(remaining_rules, remaining_string, new_tokens)
  end
end
