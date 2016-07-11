defmodule CLDRex.Parsers.DateTimeParser do
  @moduledoc false
  alias CLDRex.Main
  alias CLDRex.Directive


  @cldr_chars ~r/\A[yYuUrRMLwWdDFgEecabhHKkmsSA]+/

  @rules [
    # Year
    {~r/[yur]{3,}/i, Directive.get(:year, zero_padding: true, date_part: :year)},
    {~r/[yur]{2}/i,  Directive.get(:year2, date_part: :year)},
    {~r/[yur]/i,     Directive.get(:year, date_part: :year)},
    # Month
    {~r/M{5}/,       Directive.get(:month_narrow, date_part: :month)},
    {~r/M{4}/,       Directive.get(:month_wide, date_part: :month)},
    {~r/M{3}/,       Directive.get(:month_abrv, date_part: :month)},
    {~r/M{1,2}/,     Directive.get(:month, date_part: :month)},
    {~r/L{5}/,       Directive.get(:smonth_narrow, date_part: :month)},
    {~r/L{4}/,       Directive.get(:smonth_wide, date_part: :month)},
    {~r/L{3}/,       Directive.get(:smonth_abrv, date_part: :month)},
    {~r/L{1,2}/,     Directive.get(:month, date_part: :month)},
    # Week
    {~r/w{1,2}/,     Directive.get(:week, date_part: :week)},
    {~r/W/,          Directive.get(:mweek, date_part: :week)},
    # Day
    {~r/d{1,2}/,     Directive.get(:day, date_part: :day)},
    {~r/D{1,3}/,     Directive.get(:yday, date_part: :day)},
    {~r/F/,          Directive.get(:dwday, date_part: :day)},
    {~r/g{1,}/,      Directive.get(:mjday, date_part: :day)},
    # Week Day
    {~r/E{6}/,       Directive.get(:wd_short, date_part: :week_day)},
    {~r/E{5}/,       Directive.get(:wd_narrow, date_part: :week_day)},
    {~r/E{4}/,       Directive.get(:wd_wide, date_part: :week_day)},
    {~r/E{1,3}/,     Directive.get(:wd_abrv, date_part: :week_day)},
    {~r/e{6}/,       Directive.get(:lwd_short, date_part: :week_day)},
    {~r/e{5}/,       Directive.get(:lwd_narrow, date_part: :week_day)},
    {~r/e{4}/,       Directive.get(:lwd_wide, date_part: :week_day)},
    {~r/e{3}/,       Directive.get(:lwd_abrv, date_part: :week_day)},
    {~r/e{1,2}/,     Directive.get(:week_day, date_part: :week_day)},
    {~r/c{6}/,       Directive.get(:swd_short, date_part: :week_day)},
    {~r/c{5}/,       Directive.get(:swd_narrow, date_part: :week_day)},
    {~r/c{4}/,       Directive.get(:swd_wide, date_part: :week_day)},
    {~r/c{3}/,       Directive.get(:swd_abrv, date_part: :week_day)},
    {~r/c/,          Directive.get(:week_day, date_part: :week_day)},
    # Period
    {~r/a{5}/,       Directive.get(:period_narrow, date_part: :hour)}, # Not fully supported yet
    {~r/a{4}/,       Directive.get(:period_wide, date_part: :hour)},   # Not fully supported yet
    {~r/a{1,3}/,     Directive.get(:period_abrv, date_part: :hour)},   # Not fully supported yet
    {~r/b{5}/i,      Directive.get(:period_narrow, date_part: :hour)}, # Not fully supported yet
    {~r/b{4}/i,      Directive.get(:period_wide, date_part: :hour)},   # Not fully supported yet
    {~r/b{1,3}/i,    Directive.get(:period_abrv, date_part: :hour)},   # Not fully supported yet
    # Hour
    {~r/h{1,2}/,     Directive.get(:hour12, date_part: :hour)},
    {~r/H{1,2}/,     Directive.get(:hour24, date_part: :hour, zero_padding: true)},
    {~r/K{1,2}/,     Directive.get(:hour12, date_part: :hour, zero_padding: true)},
    {~r/k{1,2}/,     Directive.get(:hour24, date_part: :hour)},
    # Minute
    {~r/m{1,2}/,     Directive.get(:minute, date_part: :minute)},
    # Second
    {~r/s{1,2}/,     Directive.get(:second, date_part: :second)},
    {~r/S{1,}/,      Directive.get(:fsecond, date_part: :second)},    # Not fully supported
    {~r/A{1,}/,      Directive.get(:millisecond, date_part: :second)} # Not fully supported
    # Zone
      # TODO
  ]


  def parse(format_string) do
    format_string
    |> to_string
    |> do_parse([])
    |> find_directives
  end

  defp do_parse(<<>>, tokens), do: tokens
  defp do_parse(format_string, tokens) do
    {token, remaining_string} = case Regex.run(@cldr_chars, format_string) do
      nil     ->
        String.split_at(format_string, 1)
      matches ->
        match = Enum.at(matches, 0)
        remaining = format_string
          |> String.split(match)
          |> Enum.at(1)

        {match, remaining}
    end

    new_tokens = Enum.concat(tokens, [token])

    do_parse(remaining_string, new_tokens)
  end

  defp find_directives(tokens) do
    Enum.reduce tokens, [], fn (token, acc) ->
      Enum.concat(acc, [match_rule(token)])
    end
  end

  defp match_rule(token) do
    case Enum.find(@rules, fn ({r, _}) -> token =~ r end) do
      nil    -> token
      {r, d} -> %{d | token: token}
    end
  end
end
