defmodule Uzi.Models.Request do
  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          state: String.t(),
          tracking_id: Ecto.UUID.t(),
          url: String.t(),
          payload: String.t(),
          response: String.t() | nil,
          callback_payload: String.t() | nil,
          result: String.t() | nil,
          sent_at: String.t(),
          completed_at: DateTime.t() | nil,
          duration_ms: Integer.t() | nil,
          updated_at: DateTime.t() | nil,
          created_at: DateTime.t() | nil
        }

  use Ecto.Schema
  import Ecto.Changeset

  @complete_fields [
    :callback_payload,
    :result,
    :completed_at,
    :duration_ms
  ]

  @primary_key {:id, Uzi.Models.EctoTypeUUID, autogenerate: true}

  schema "requests" do
    field :state, :string
    field :tracking_id, :string
    field :url, :string
    field :payload, :string
    field :response, :string
    field :callback_payload, :string
    field :result, :string
    field :sent_at, :naive_datetime_usec
    field :completed_at, :naive_datetime_usec
    field :duration_ms, :integer

    timestamps(inserted_at: :created_at)
  end

  def create(url, payload, tracking_id) do
    __struct__()
    |> change(
      state: "new",
      url: url,
      payload: inspect(payload),
      tracking_id: tracking_id,
      sent_at: NaiveDateTime.utc_now()
    )
    |> Uzi.Repo.insert!()
  end

  def mark_pending(req, response) do
    req
    |> change(
      state: "pending",
      response: inspect(response)
    )
    |> Uzi.Repo.update!()
  end

  def mark_error(req, error) do
    req
    |> change(
      state: "error",
      response: inspect(error)
    )
    |> Uzi.Repo.update!()
  end

  def mark_completed(req, params) do
    req
    |> cast(params, @complete_fields)
    |> change(state: "completed")
    |> Uzi.Repo.update!()
  end

  def find_by_tracking_id(id) do
    Uzi.Repo.get_by!(__MODULE__, tracking_id: id)
  end
end
