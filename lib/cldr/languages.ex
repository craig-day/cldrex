defmodule CLDR.Languages do
  @moduledoc """
  Provide a list of all languages and their localized name.
  """
  require CLDR.Main

  alias CLDR.Main
  alias CLDR.Utils

  @type locale :: atom | String.t

  @doc """
  Return a `Map` of languages, where each language is localized in its native
  language.
  """
  @spec all :: Map.t
  def all do
    Enum.reduce Main.cldr_main_data, %{}, fn(l, acc) ->
      {locale, %{display_pattern: _dp, languages: languages}} = l

      fallback = Utils.fallback(locale)

      languages_with_fallback = Map.get_lazy(languages, locale, fn ->
        %{display_pattern: _, languages: fbl} = Map.get(Main.cldr_main_data, fallback, %{})
        Map.get_lazy(fbl, locale, fn ->
          Map.get(fbl, fallback, to_string(locale))
        end)
      end)

      Map.put(acc, locale, languages_with_fallback)
    end
  end

  @doc """
  Return a `Map` of languages localized in the given `locale`.
  """
  @spec all_for(locale) :: Map.t
  def all_for(locale) do
    locale = Utils.normalize_locale(locale)
    fallback = Utils.fallback(locale)

    %{display_pattern: _, languages: languages} = Map.get(Main.cldr_main_data, locale)

    if Enum.empty?(languages),
      do: %{display_pattern: _, languages: languages} = Map.get(Main.cldr_main_data, fallback)

    languages
  end
end
