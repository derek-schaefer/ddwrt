defmodule DDWRT.DHCP.Lease do
  defstruct [:name, :ip, :mac, :period]

  def new(entry) when is_list(entry) do
    %__MODULE__{
      name: Enum.at(entry, 0),
      ip: Enum.at(entry, 1),
      mac: Enum.at(entry, 2),
      period: Enum.at(entry, 3)
    }
  end
end
