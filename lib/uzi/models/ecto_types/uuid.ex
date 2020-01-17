defmodule Uzi.EctoTypes.UUID do
  @type t :: Ecto.UUID.t()

  @behaviour Ecto.Type

  @impl Ecto.Type
  def cast(string) when is_bitstring(string), do: {:ok, string}
  def cast(_), do: :error

  @impl Ecto.Type
  def dump(string) when is_bitstring(string), do: {:ok, string}
  def dump(_), do: :error

  @impl Ecto.Type
  def load(string) when is_bitstring(string), do: {:ok, string}
  def load(_), do: :error

  @impl Ecto.Type
  def type(), do: :string

  @impl Ecto.Type
  def equal?(val1, val2), do: val1 == val2

  @impl Ecto.Type
  def embed_as(_), do: :self

  @spec autogenerate() :: String.t()
  def autogenerate(), do: Ecto.UUID.generate()
end
