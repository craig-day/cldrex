# This module shouldn't be interfaced with publically.  It parses the XML files
# in priv/data/common to extract the needed data.
defmodule CLDRex.Parsers.XMLParser do
  @moduledoc false
  import SweetXml

  @data_path Path.expand("../../../priv/data/common", __DIR__)
  @main_path Path.join(@data_path, "main")
  @ldml_path Path.join([@data_path, "dtd", "ldml.dtd"])

  @doc false
  def parse_main_data do
    @main_path
      |> File.ls!
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

    locale = build_locale_from_file(file)

    Map.put(%{}, locale, %{
      display_pattern: extract_display_pattern(doc),
      languages: extract_languages(doc),
      territories: extract_territories(doc),
      calendar: extract_calendar(doc)
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
    |> extract_calendar_map
    |> process_calendar_map
  end

  defp extract_calendar_map(doc) do
    xmap(doc, calendars: [
      ~x"//dates/calendars/calendar"l,
      type: ~x"./@type",
      month_contexts: [
        ~x"./months/monthContext"l,
        name: ~x"./@type",
        formats: [
          ~x"./monthWidth"l,
          name: ~x"./@type",
          months: [
            ~x"./month"l,
            month: ~x"./@type",
            label: ~x"./text()"
          ]
        ]
      ],
      day_contexts: [
        ~x"./days/dayContext"l,
        name: ~x"./@type",
        formats: [
          ~x"./dayWidth"l,
          name: ~x"./@type",
          days: [
            ~x"./day"l,
            day: ~x"./@type",
            label: ~x"./text()"
          ]
        ]
      ],
      date_formats: [
        ~x"./dateFormats/dateFormatLength"l,
        length: ~x"./@type",
        format: ~x"./dateFormat/pattern/text()"
      ],
      time_formats: [
        ~x"./timeFormats/timeFormatLength"l,
        length: ~x"./@type",
        format: ~x"./timeFormat/pattern/text()"
      ],
      date_time_formats: [
        ~x"./dateTimeFormats/dateTimeFormatLength"l,
        length: ~x"./@type",
        format: ~x"./dateTimeFormat/pattern/text()"
      ]
    ])
  end

  defp process_calendar_map(xdoc) do
    Enum.reduce xdoc, %{}, fn(data, _acc) ->
      {_, calendars} = data
      Enum.reduce(calendars, %{}, fn(cal, cacc) ->
        mc = Enum.reduce(cal.month_contexts, %{}, fn(mctxt, mcacc) ->
          f = Enum.reduce(mctxt.formats, %{}, fn(fmt, facc) ->
            m = Enum.reduce(fmt.months, %{}, fn(month, macc) ->
              Map.put(macc, String.to_atom(to_string(month.month)), month.label)
            end)
            Map.put(facc, String.to_atom(to_string(fmt.name)), m)
          end)
          Map.put(mcacc, String.to_atom(to_string(mctxt.name)), f)
        end)

        dc = Enum.reduce(cal.day_contexts, %{}, fn(dctxt, dcacc) ->
          f = Enum.reduce(dctxt.formats, %{}, fn(fmt, facc) ->
            m = Enum.reduce(fmt.days, %{}, fn(day, macc) ->
              Map.put(macc, String.to_atom(to_string(day.day)), day.label)
            end)
            Map.put(facc, String.to_atom(to_string(fmt.name)), m)
          end)
          Map.put(dcacc, String.to_atom(to_string(dctxt.name)), f)
        end)

        datec = Enum.reduce(cal.date_formats, %{}, fn(datectxt, dateacc) ->
          length = datectxt.length
            |> to_string
            |> String.to_atom
          Map.put(dateacc, length, to_string(datectxt.format))
        end)

        timec = Enum.reduce(cal.time_formats, %{}, fn(timectxt, timeacc) ->
          length = timectxt.length
            |> to_string
            |> String.to_atom
          Map.put(timeacc, length, to_string(timectxt.format))
        end)

        dtc = Enum.reduce(cal.date_time_formats, %{}, fn(dtctxt, dtacc) ->
          length = dtctxt.length
            |> to_string
            |> String.to_atom
          Map.put(dtacc, length, to_string(dtctxt.format))
        end)

        contexts = %{
          months: mc,
          days: dc,
          date_formats: datec,
          time_formats: timec,
          date_time_formats: dtc
        }

        Map.put(cacc, String.to_atom(to_string(cal.type)), contexts)
      end)
    end
  end

  defp build_locale_from_file(file) do
    file
    |> String.slice(0..-5)
    |> String.to_atom
  end
end
