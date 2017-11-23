defmodule DDWRT.DHCP do
  @moduledoc """
  DDWRT.DHCP
  """

  alias DDWRT.DHCP.Lease

  @type t :: %__MODULE__{leases: [Lease.t]}
  defstruct leases: []

  @dhcp_leases "dhcp_leases"

  @doc """
  new
  """
  @spec new(%{String.t => String.t}) :: t
  def new(results) when is_map(results) do
    %__MODULE__{
      leases: leases(results)
    }
  end

  @spec leases(%{String.t => String.t}) :: [Lease.t]
  defp leases(results) do
    results
    |> Map.fetch!(@dhcp_leases)
    |> DDWRT.extract_and_chunk_entries(5)
    |> Enum.map(&Lease.new/1)
  end
end
