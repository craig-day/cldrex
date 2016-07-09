# This is a hacky intermediate module that will call the Data module to parse
# the files on commaned line.  This module can then be included in other modules
# that need access to the data.
defmodule CLDRex.Main do
  @moduledoc false
  require CLDRex.Data

  @data CLDRex.Data.main_data

  @doc false
  def cldr_main_data, do: @data
end
