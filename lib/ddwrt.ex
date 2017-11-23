defmodule DDWRT do
  alias DDWRT.{DHCP, Wireless}

  defstruct address: "http://192.168.1.1", username: "root", password: nil

  def status_wireless(%__MODULE__{} = settings) do
    with {:ok, results} <- get_results(settings, "/Status_Wireless.live.asp"), do: results |> Wireless.new |> success
  end

  def status_lan(%__MODULE__{} = settings) do
    with {:ok, results} <- get_results(settings, "/Status_Lan.live.asp"), do: results |> DHCP.new |> success
  end

  def get_results(%__MODULE__{} = settings, path) do
    with {:ok, response} <- get(settings, path), do: response.body |> extract_results |> success
  end

  def get(%__MODULE__{} = settings, path) do
    HTTPoison.get(settings.address <> path, headers(settings))
  end

  def headers(%__MODULE__{} = settings) do
    [authorization: "Basic " <> authorization(settings)]
  end

  def authorization(%__MODULE__{} = settings) do
    Base.encode64(settings.username <> ":" <> settings.password)
  end

  def extract_results(payload) do
    Regex.scan(~r/{(\w+)::(.*)}/, payload)
    |> Enum.map(&Enum.slice(&1, 1..2))
    |> Enum.map(fn result -> Enum.map(result, &String.trim/1) end)
    |> Map.new(&List.to_tuple/1)
  end

  def extract_entries(value) do
    Regex.scan(~r/'((?:[^'\\]|\\.)*)'/, value)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.map(&String.trim/1)
  end

  def extract_and_chunk_entries(value, size) do
    value |> extract_entries |> Enum.chunk_every(size)
  end

  defp success(value), do: {:ok, value}
end
