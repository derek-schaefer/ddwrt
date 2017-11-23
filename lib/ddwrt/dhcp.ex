defmodule DDWRT.DHCP do
  alias DDWRT.DHCP.Lease

  defstruct leases: []

  @dhcp_leases "dhcp_leases"

  def new(results) when is_map(results) do
    %__MODULE__{
      leases: leases(results)
    }
  end

  defp leases(results) do
    results
    |> Map.fetch!(@dhcp_leases)
    |> DDWRT.extract_and_chunk_entries(5)
    |> Enum.map(&Lease.new/1)
  end
end
