defmodule Uzi.Requests.Info do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  @cast_fields [
    :url,
    :payload,
    :threads_count,
    :requests_per_thread_count,
    :timeout_between_requests_millisec
  ]

  embedded_schema do
    field :url, :string
    field :payload, :map
    field :threads_count, :integer
    field :requests_per_thread_count, :integer
    field :timeout_between_requests_millisec, :integer
  end

  def new(params) do
    __struct__()
    |> cast(params, @cast_fields)
    |> apply_changes()
  end
end
