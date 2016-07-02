defmodule DatesTimes do
  @moduledoc """

  """

  @spec localize(Date.t, atom) :: String.t
  def localize(date, locale)

  @spec localize(Date.t, atom, %{...}) :: String.t
  def localize(date, locale, options)

  @spec localize(DateTime.t, atom) :: String.t
  def localize(datetime, locale)

  @spec localize(DateTime.t, atom, %{...}) :: String.t
  def localize(datetime, locale, options)

  @spec localize(Time.t, atom) :: String.t
  def localize(time, locale)

  @spec localize(Time.t, atom, %{...}) :: String.t
  def localize(time, locale, options)
end
