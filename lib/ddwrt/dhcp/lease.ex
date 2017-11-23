defmodule DDWRT.DHCP.Lease do
  @moduledoc """
  DDWRT.DHCP.Lease
  """

  @type t :: %__MODULE__{name: String.t, ip: String.t, mac: String.t, period: String.t}
  defstruct [:name, :ip, :mac, :period]

  @doc """
  new
  """
  @spec new([String.t]) :: t
  def new(entry) when is_list(entry) do
    %__MODULE__{
      name: Enum.at(entry, 0),
      ip: Enum.at(entry, 1),
      mac: Enum.at(entry, 2),
      period: Enum.at(entry, 3)
    }
  end
end
