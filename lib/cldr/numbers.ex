defmodule CLDR.Numbers do
  @moduledoc """

  """

  @spec localize(number, atom) :: String.t
  def localize(number, locale)

  @spec localize(number, atom, %{...}) :: String.t
  def localize(number, locale, options)
end
