defmodule Uzi.Models.ComplianceCheckRequest do
  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          state: String.t(),
          tracking_id: Ecto.UUID.t(),
          url: String.t(),
          payload: String.t(),
          response: String.t() | nil,
          screening_result: String.t() | nil,
          sent_at: String.t(),
          completed_at: DateTime.t() | nil ,
          duration_ms: Integer.t() | nil,
          updated_at: DateTime.t() | nil,
          created_at: DateTime.t() | nil
        }

  use Ecto.Schema
  import Ecto.Changeset

  @create_fields [
    :state,
    :tracking_id,
    :url,
    :payload,
    :response,
    :sent_at
  ]

  @complete_fields [
    :state,
    :response,
    :screening_result,
    :completed_at,
    :duration_ms
  ]

  @primary_key {:id, Uzi.EctoTypes.UUID, autogenerate: true}

  schema "compliance_check_requests" do
    field :state, :string
    field :tracking_id, :string
    field :url, :string
    field :payload, :string
    field :response, :string
    field :screening_result, :string
    field :sent_at, :naive_datetime
    field :completed_at, :naive_datetime
    field :duration_ms, :integer

    timestamps(inserted_at: :created_at)
  end

  def create(params) do
    __struct__()
    |> cast(params, @create_fields)
    |> Uzi.Repo.insert!()
  end

  def mark_completed(req, params) do
    req
    |> cast(params, @complete_fields)
    |> Uzi.Repo.update()
  end

  def find_by_tracking_id(id) do
    Uzi.Repo.get_by(__MODULE__, tracking_id: id)
  end
end
