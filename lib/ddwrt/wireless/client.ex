defmodule DDWRT.Wireless.Client do
  @moduledoc """
  DDWRT.Wireless.Client
  """

  @type t :: %__MODULE__{mac: String.t}
  defstruct [:mac]

  @doc """
  new
  """
  @spec new([String.t]) :: __MODULE__.t
  def new(entry) when is_list(entry) do
    %__MODULE__{
      mac: Enum.at(entry, 0)
    }
  end
end
