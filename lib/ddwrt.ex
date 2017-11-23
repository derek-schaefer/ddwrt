defmodule DDWRT do
  @moduledoc """
  DDWRT
  """

  alias DDWRT.{DHCP, Wireless}

  @type t :: %__MODULE__{address: String.t, username: String.t, password: String.t}
  defstruct address: "http://192.168.1.1", username: "root", password: nil

  @doc """
  Retrieves the wireless status and extracts the results as a `DDWRT.Wireless` record.
  """
  @spec status_wireless(t) :: {:ok, Wireless.t} | {:error, HTTPoison.Error.t}
  def status_wireless(%__MODULE__{} = settings) do
    with {:ok, results} <- get_results(settings, "/Status_Wireless.live.asp") do
      results |> Wireless.new |> success
    end
  end

  @doc """
  Retrieves the LAN status and extracts the results as a `DDWRT.DHCP` record.
  """
  @spec status_lan(t) :: {:ok, DHCP.t} | {:error, HTTPoison.Error.t}
  def status_lan(%__MODULE__{} = settings) do
    with {:ok, results} <- get_results(settings, "/Status_Lan.live.asp") do
      results |> DHCP.new |> success
    end
  end

  @doc """
  Issues a GET request and extracts the results as a map if successful.
  """
  @spec get_results(t, String.t) :: {:ok, %{String.t => String.t}} | {:error, HTTPoison.Error.t}
  def get_results(%__MODULE__{} = settings, path) do
    with {:ok, response} <- get(settings, path) do
      response.body |> extract_results |> success
    end
  end

  @doc """
  Issues an authenticated GET request to the given path relative to the configured address.
  """
  @spec get(t, String.t) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  def get(%__MODULE__{} = settings, path) do
    HTTPoison.get(settings.address <> path, headers(settings))
  end

  @doc """
  Constructs a list of tuples to be used as HTTP request headers.
  """
  @spec headers(t) :: [{String.t, String.t}]
  def headers(%__MODULE__{} = settings) do
    [{"Authorization", "Basic " <> authorization(settings)}]
  end

  @doc """
  Encodes the username and password to be used for HTTP basic authentication.
  """
  @spec authorization(t) :: String.t
  def authorization(%__MODULE__{} = settings) do
    Base.encode64(settings.username <> ":" <> settings.password)
  end

  @doc """
  Extracts a map of results from a payload with a pattern of `{key::value}` pairs.
  """
  @spec extract_results(String.t) :: %{String.t => String.t}
  def extract_results(payload) do
    Regex.scan(~r/{(\w+)::(.*)}/, payload)
    |> Enum.map(&Enum.slice(&1, 1..2))
    |> Enum.map(fn result -> Enum.map(result, &String.trim/1) end)
    |> Map.new(&List.to_tuple/1)
  end

  @doc """
  Extracts a list of entries from a result value with a pattern of `'entry1','entry2','entry3'`.
  """
  @spec extract_entries(String.t) :: [String.t]
  def extract_entries(value) do
    Regex.scan(~r/'((?:[^'\\]|\\.)*)'/, value)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.map(&String.trim/1)
  end

  @doc """
  A convenience function for extracting and chunking entries from a result value.
  """
  @spec extract_and_chunk_entries(String.t, integer) :: [[String.t]]
  def extract_and_chunk_entries(value, size) do
    value |> extract_entries |> Enum.chunk_every(size)
  end

  defp success(value), do: {:ok, value}
end
