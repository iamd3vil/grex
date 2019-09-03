defmodule Grex.Client do
  defstruct [:key]

  @spec new(String.t()) :: {:ok, Grex.Client.t()}
  def new(key) do
    {:ok, %__MODULE__{key: key}}
  end
end
