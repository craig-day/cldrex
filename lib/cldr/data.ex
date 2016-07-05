# This module shouldn't be interfaced with publically.  It parses the XML files
# in data/common to extract the needed data.
defmodule CLDRex.Data do
  @moduledoc false
  import SweetXml

  @data_path Path.expand("./data/common")
  @main_path Path.join(@data_path, "main")
  @ldml_path Path.join([@data_path, "dtd", "ldml.dtd"])

  @doc false
  def main_data do
    @main_path
      |> File.ls!
      |> Enum.take(1)
      |> process_files
  end

  defp process_files(files) do
    Enum.reduce files, %{}, fn(f, acc) ->
      Map.merge(acc, process_file(f))
    end
  end

  defp process_file(file) do
    # the replace is an ugly hack because the doc uses a relative path which
    # breaks at compile time, so we need to change that path
    doc = @main_path
      |> Path.join(file)
      |> File.read!
      |> String.replace(~r/(<!DOCTYPE ldml SYSTEM ").*?(">)/, "\\1#{@ldml_path}\\2")

    display_pattern = extract_display_pattern(doc)
    languages = extract_languages(doc)
    territories = extract_territories(doc)
    locale = build_locale_from_file(file)

    Map.put(%{}, locale, %{
      display_pattern: display_pattern,
      languages: languages,
      territories: territories
    })
  end

  defp extract_display_pattern(doc) do
    doc
    |> xpath(~x"//localeDisplayPattern/localePattern/text()")
    |> to_string
  end

  defp extract_languages(doc) do
    doc
    |> xpath(~x"//languages/language"l,
      locale: ~x"./@type", language: ~x"./text()")
    |> Enum.reduce(%{}, fn(l, acc) ->
      loc = l.locale |> to_string |> String.to_atom
      lng = l.language |> to_string
      Map.put(acc, loc, lng)
    end)
  end

  defp extract_territories(doc) do
    doc
    |> xpath(~x"//territories/territory"l,
      un_code: ~x"./@type", name: ~x"./text()")
    |> Enum.reduce(%{}, fn(l, acc) ->
      code = l.un_code |> to_string |> String.to_atom
      name = l.name |> to_string
      Map.put(acc, code, name)
    end)
  end

  defp extract_calendar(doc) do
    doc
    |> xpath(~x"//dates/calendars/calendar[@type='gregorian']/")
    |> inspect
    |> IO.puts
    # |> Enum.reduce(%{}, fn(l, acc) ->
    #   code = l.un_code |> to_string |> String.to_atom
    #   name = l.name |> to_string
    #   Map.put(acc, code, name)
    # end)
  end

  defp build_locale_from_file(file) do
    file
    |> String.slice(0..-5)
    |> String.to_atom
  end
end
