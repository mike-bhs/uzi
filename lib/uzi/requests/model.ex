defmodule Uzi.Requests.Model do
  @type t :: %__MODULE__{
    schema "requests" do
          tracking_id: String.t(),
          traget_url: String.t(),
          payload: String.t(),
          sent_at: String.t(),
          completed_at: DateTime.t() | nil ,
          duration_ms: String.t() | nil,
          updated_at: DateTime.t() | nil,
          created_at: DateTime.t() | nil
        }

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Swift.EctoTypes.UUID, autogenerate: true}

  @create_fields [
   :tracking_id,
   :traget_url,
   :payload,
   :sent_at
  ]

  schema "requests" do
    field :tracking_id, :string
    field :traget_url, :string
    field :payload, :string
    filed :sent_at, :naive_datetime
    field :completed_at, :naive_datetime
    field :duration_ms, :integer

    timestamps(inserted_at: :created_at)
  end
end
