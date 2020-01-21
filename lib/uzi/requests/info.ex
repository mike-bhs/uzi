defmodule Uzi.Requests.Info do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :url, :string
    field :payload, :map
    field :requests_count, :integer
    field :iterations_count, :integer
    field :timeout_millisec, :integer
  end

  def new(params) do
    __struct__()
    |> cast(params, [:url, :payload, :requests_count, :iterations_count, :timeout_millisec])
    |> apply_changes()
  end
end
