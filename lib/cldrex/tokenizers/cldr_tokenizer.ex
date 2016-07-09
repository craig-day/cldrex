defmodule CLDRex.Tokenizers.CLDRTokenizer do
  import Combine.Parsers.Base
  import Combine.Parsers.Text

  use Timex.Parse.DateTime.Tokenizer

  @rules [~r/G{1,5}/,
    ~r/[yur]{1,}/i,
    ~r/Q{1,5}/i,
    ~r/M{1,5}/,
    ~r/L{1,5}/,
    ~r/w{1,2}/,
    ~r/W/,
    ~r/d{1,2}/,
    ~r/D{1,3}/,
    ~r/F/,
    ~r/g{1,}/,
    ~r/E{1,6}/i,
    ~r/c/,
    ~r/c{3,6}/,
    ~r/a{1,5}/,
    ~r/b{1,5}/,
    ~r/h{1,2}/i,
    ~r/k{1,2}/i,
    ~r/m{1,2}/,
    ~r/s{1,2}/,
    ~r/S{1,}/,
    ~r/A{1,}/,
    ~r/z{1,4}/,
    ~r/Z{1,5}/,
    ~r/O/,
    ~r/O{4}/,
    ~r/v/,
    ~r/v{4}/,
    ~r/V{1,4}/,
    ~r/x{1,5}/i
  ]

  @doc """
  Tokenizes the given format string and returns an error or a list of directives.
  """
  @spec tokenize(String.t) :: [Directive.t] | {:error, term}
  def tokenize(<<>>), do: {:error, "Format string cannot be empty."}
  def tokenize(format_string) do
    # case Combine.parse(format_string, parser) do
    #   results when is_list(results) ->
    #     directives = results |> List.flatten |> Enum.filter(fn x -> x !== nil end)
    #     case Enum.any?(directives, fn %Directive{type: type} -> type != :literal end) do
    #       false -> {:error, "Invalid format string, must contain at least one directive."}
    #       true  -> {:ok, directives}
    #     end
    #   {:error, _} = err -> err
    # end
    apply_rules(@rules, format_string)
    {:ok, []}
  end

  # Private

  defp apply_rules(rules, format_string, tokens \\ [])

  defp apply_rules(rules, format_string, tokens) when rules == [] do
    Enum.each(tokens, fn(token) -> coalesce_token(token) end)
  end

  defp apply_rules(rules, format_string, tokens) do
    {rule, remaining_rules} = Enum.split(rules, 1)
    rule = Enum.at(rule, 0)
    run = Regex.run(rule, format_string)
    match = if run, do: Enum.at(run, 0)

    {new_tokens, remaining_string} = case match do
      nil -> {tokens, format_string}
      _   -> {Enum.concat(tokens, [[match]]),
        String.replace(format_string, match, "*", global: false)}
    end

    apply_rules(remaining_rules, remaining_string, new_tokens)
  end

  defp coalesce_token([directive]) do
    flags     = []
    width     = [min: -1, max: nil]
    modifiers = []
    map_directive(directive, [flags: flags, width: width, modifiers: modifiers])
  end

  defp map_directive(d, opts) do
    cond do
      # Year
      d =~ ~r/[yur]{3,}/i -> d |> String.length |> force_width(:year4, d, opts)
      d =~ ~r/[yur]{2}/i  -> d |> String.length |> force_width(:year4, d, opts)
      d =~ ~r/[yur]/i     -> d |> String.length |> force_width(:year4, d, opts)
      # Month
      d =~ ~r/M{5}/   -> force_width(1, :mfull, d, opts)
      d =~ ~r/M{4}/   -> Directive.get(:mfull, d, opts)
      d =~ ~r/M{3}/   -> Directive.get(:mshort, d, opts)
      d =~ ~r/M{1,2}/ -> d |> String.length |> force_width(:month, d, opts)
      d =~ ~r/L{5}/   -> force_width(1, :mfull, d, opts)
      d =~ ~r/L{4}/   -> Directive.get(:mfull, d, opts)
      d =~ ~r/L{3}/   -> Directive.get(:mshort, d, opts)
      d =~ ~r/L{1,2}/ -> d |> String.length |> force_width(:month, d, opts)
      # Week
      d =~ ~r/w{1,2}/ -> d |> String.length |> force_width(:iso_weeknum, d, opts)
      d =~ ~r/W/      -> Directive.get(:iso_weeknum, d, opts)
      # Day
      d =~ ~r/d{1,2}/ -> d |> String.length |> force_width(:day, d, opts)
      d =~ ~r/D{1,3}/ -> d |> String.length |> force_width(:oday, d, opts)
      # not supported yet # d =~ ~r/F/      ->
      # not supported yet # d =~ ~r/g{1,}/  -> []
      # Week Day
      d =~ ~r/E{6}/   -> force_width(1, :wdfull, d, opts)
      d =~ ~r/E{5}/   -> []
      d =~ ~r/E{4}/   -> []
      d =~ ~r/E{1,3}/ -> []
      d =~ ~r/e{6}/   -> []
      d =~ ~r/e{5}/   -> []
      d =~ ~r/e{4}/   -> []
      d =~ ~r/e{3}/   -> []
      d =~ ~r/e{1,2}/ -> []
      d =~ ~r/c{6}/   -> []
      d =~ ~r/c{5}/   -> []
      d =~ ~r/c{4}/   -> []
      d =~ ~r/c{3}/   -> []
      d =~ ~r/c/      -> []
      # Period
      d =~ ~r/a{5}/    -> []
      d =~ ~r/a{4}/    -> []
      d =~ ~r/a{1,3}/  -> []
      d =~ ~r/b{5}/i   -> []
      d =~ ~r/b{4}/i   -> []
      d =~ ~r/b{1,3}/i -> []
      # Hour
      d =~ ~r/h{1,2}/ -> []
      d =~ ~r/H{1,2}/ -> []
      d =~ ~r/K{1,2}/ -> []
      d =~ ~r/k{1,2}/ -> []
      # Minute
      d =~ ~r/m{1,2}/ -> []
      # Second
      d =~ ~r/s{1,2}/ -> []
      d =~ ~r/S{1,}/  -> []
      d =~ ~r/A{1,}/  -> []
      # Zone
      d =~ ~r/z{4}/    -> []
      d =~ ~r/z{1,3}/  -> []
      d =~ ~r/Z{5}/    -> []
      d =~ ~r/Z{4}/    -> []
      d =~ ~r/Z{1,3}/  -> []
      d =~ ~r/O{4}/    -> []
      d =~ ~r/O/       -> []
      d =~ ~r/v{4}/    -> []
      d =~ ~r/v/       -> []
      d =~ ~r/V{1,4}/  -> []
      d =~ ~r/x{1,5}/i -> []
    end
  end

  defp set_width(min, max, type, directive, opts) do
    opts = Keyword.merge(opts, [width: [min: min, max: max]])
    Directive.get(type, directive, opts)
  end

  defp force_width(size, type, directive, opts) do
    flags     = Keyword.merge([padding: :zeroes], get_in(opts, [:flags]))
    mods      = get_in(opts, [:modifiers])
    Directive.get(type, directive, [flags: flags, modifiers: mods, width: [min: size, max: size]])
  end
end
