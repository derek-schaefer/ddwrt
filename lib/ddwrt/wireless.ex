defmodule DDWRT.Wireless do
  @moduledoc """
  DDWRT.Wireless
  """

  alias DDWRT.Wireless.Client

  @type t :: %__MODULE__{clients: [Client.t]}
  defstruct clients: []

  @active_wireless "active_wireless"

  @doc """
  new
  """
  @spec new(%{String.t => String.t}) :: __MODULE__.t
  def new(results) when is_map(results) do
    %__MODULE__{
      clients: clients(results)
    }
  end

  @spec clients(%{String.t => String.t}) :: [Client.t]
  defp clients(results) do
    results
    |> Map.fetch!(@active_wireless)
    |> DDWRT.extract_and_chunk_entries(9)
    |> Enum.map(&Client.new/1)
  end
end
