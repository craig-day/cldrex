defmodule CLDRex.Languages do
  @moduledoc """
  Provide a list of all languages and their localized name.
  """
  alias CLDRex.Main
  import CLDRex.Utils

  @type locale :: atom | String.t

  @doc """
  Return a `Map` of languages, where each language is localized in its native
  language.

  ## Examples

  ```
  iex> CLDRex.Languages.all
  %{ast: "asturianu", bem_ZM: "Ichibemba", ar_KM: "العربية",
    cu: "церковнослове́нскїй", tzm: "Tamaziɣt n laṭlaṣ",
    sg: "Sängö", en_PR: "English", id: "Indonesia", uz: "o‘zbek",
    ki_KE: "Gikuyu", ps_AF: "پښتو", os_GE: "ирон", zh_Hans_SG: "中文",
    sv_AX: "svenska", ast_ES: "asturianu", en_SB: "English", nl_BE: "Vlaams",
    tzm_MA: "Tamaziɣt n laṭlaṣ", asa_TZ: "Kipare", fr_CH: "français suisse",
    lb_LU: "Lëtzebuergesch", sr_Cyrl_ME: "српски", ga: "Gaeilge",
    ga_IE: "Gaeilge", ar_EG: "العربية", ksh: "Kölsch", af: "Afrikaans",
    en_001: "English", is_IS: "íslenska", mgh: "Makua", jgo: "Ndaꞌa",
    kkj_CM: "kakɔ", vi: "Tiếng Việt", ar_DZ: "العربية",
    ms_BN: "Bahasa Melayu", mzn_IR: "مازرونی",
    zgh_MA: "ⵜⴰⵎⴰⵣⵉⵖⵜ", ro_RO: "română",
    ar_SO: "العربية", ii_CN: "ꆈꌠꉙ", ak_GH: "Akan", it: "italiano",
    en_PK: "English", ak: "Akan", ar_OM: "العربية",
    ar_JO: "العربية", az: "azəri", ff: "Pulaar", ksh_DE: "Kölsch",
    fr_WF: "français", ...}
  ```

  """
  @spec all :: Map.t
  def all do
    Enum.reduce Main.cldr_main_data, %{}, fn(l, acc) ->
      {locale, locale_data} = l

      locale_data |> inspect |> IO.puts
      # name = get_in(locale_data,
      #   ["localeDisplayNames"])

      # name |> inspect |> IO.puts

      # Map.put(acc, locale, name)
    end
  end

  @doc """
  Return a `Map` of languages localized in the given `locale`.

  ## Examples

  ```
  iex> CLDRex.Languages.all_for(:en)
  %{sdh: "Southern Kurdish", ast: "Asturian", gn: "Guarani", mwr: "Marwari",
    nyo: "Nyoro", ban: "Balinese", sdc: "Sassarese Sardinian",
    cu: "Church Slavic", lzz: "Laz", tzm: "Central Atlas Tamazight", za: "Zhuang",
    sg: "Sango", zea: "Zeelandic", hif: "Fiji Hindi", an: "Aragonese",
    id: "Indonesian", uz: "Uzbek", phn: "Phoenician", snk: "Soninke",
    srr: "Serer", cad: "Caddo", lad: "Ladino", ch: "Chamorro", li: "Limburgish",
    tg: "Tajik", nl_BE: "Flemish", pag: "Pangasinan", bpy: "Bishnupriya",
    avk: "Kotava", egl: "Emilian", fr_CH: "Swiss French", ga: "Irish",
    ksh: "Colognian", af: "Afrikaans", nv: "Navajo", nan: "Min Nan Chinese",
    mgh: "Makhuwa-Meetto", tru: "Turoyo", sba: "Ngambay", jgo: "Ngomba",
    nso: "Northern Sotho", vep: "Veps", ceb: "Cebuano", vi: "Vietnamese",
    bej: "Beja", tli: "Tlingit", arn: "Mapuche", it: "Italian",
    ht: "Haitian Creole", ak: "Akan", ...}
  ```

  """
  @spec all_for(locale) :: Map.t
  def all_for(locale) do
    locale = normalize_locale(locale)

    get_in(Main.cldr_main_data, ~w"localeDisplayNames languages")
  end
end
