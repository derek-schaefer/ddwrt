defmodule DDWRT.Wireless.Client do
  defstruct [:mac]

  def new(entry) when is_list(entry) do
    %__MODULE__{
      mac: Enum.at(entry, 0)
    }
  end
end
