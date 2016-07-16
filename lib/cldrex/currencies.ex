defmodule CLDRex.Currencies do
  @moduledoc """
  Provide common data related to currencies.
  """
  alias CLDRex.Main

  @type locale :: atom | String.t

  @doc """
  A list of supported currency codes.

  ## Examples

  ```
  iex> CLDRex.Currencies.currency_codes
  ["XBB", "XEU", "SKK", "AUD", "CZK", "ISJ", "BRC", "IDR", "UYP", "VEF", "UAH",
   "KMF", "NGN", "NAD", "LUC", "AWG", "BRZ", "AOK", "SHP", "DEM", "UGS", "ECS",
   "BRR", "HUF", "INR", "TPE", "GYD", "MCF", "USS", "ALK", "TJR", "BGO", "BUK",
   "DKK", "LSL", "AZM", "ZRN", "MKN", "GHC", "JMD", "NOK", "GWP", "CVE", "RUR",
   "BDT", "NIC", "LAK", "XFO", "KHR", "SRD", ...]
  ```

  """
  @spec currency_codes :: list
  def currency_codes do
    data = get_in(Main.cldr_main_data, [:en, :numbers, :currencies])
    Map.keys(data)
  end

  @doc """
  Return a `Map` of currencies localized in the give `locale`.

  ## Examples

  ```
  iex> CLDRex.Currencies.all_for(:en)
  %{"XBB" => "European Monetary Unit", "XEU" => "European Currency Unit",
    "SKK" => "Slovak Koruna", "AUD" => "Australian Dollar",
    "CZK" => "Czech Republic Koruna", "ISJ" => "Icelandic Króna (1918-1981)",
    "BRC" => "Brazilian Cruzado (1986-1989)", "IDR" => "Indonesian Rupiah",
    "UYP" => "Uruguayan Peso (1975-1993)", "VEF" => "Venezuelan Bolívar",
    "UAH" => "Ukrainian Hryvnia", "KMF" => "Comorian Franc",
    "NGN" => "Nigerian Naira", "NAD" => "Namibian Dollar",
    "LUC" => "Luxembourgian Convertible Franc", "AWG" => "Aruban Florin",
    "BRZ" => "Brazilian Cruzeiro (1942-1967)", ...}
  ```

  """
  @spec all_for(locale) :: Map.t
  def all_for(locale) do
    Main.cldr_main_data
    |> get_in([locale, :numbers, :currencies])
    |> Enum.reduce(%{}, fn(c, acc) ->
      {symbol, data} = c
      Map.put(acc, symbol, Map.get(data, "displayName"))
    end)
  end
end
