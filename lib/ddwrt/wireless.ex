defmodule DDWRT.Wireless do
  alias DDWRT.Wireless.Client

  defstruct clients: []

  @active_wireless "active_wireless"

  def new(results) when is_map(results) do
    %__MODULE__{
      clients: clients(results)
    }
  end

  defp clients(results) do
    results
    |> Map.fetch!(@active_wireless)
    |> DDWRT.extract_and_chunk_entries(9)
    |> Enum.map(&Client.new/1)
  end
end
