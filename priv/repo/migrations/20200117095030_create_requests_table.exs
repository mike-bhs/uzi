defmodule Uzi.Repo.Migrations.CreateRequestsTable do
  use Ecto.Migration

  def change do
    create table(:requests, primary_key: false) do
      add :id, :string, size: 36, null: false, primary_key: true
      add :state, :string, null: false
      add :tracking_id, :string, null: false
      add :url, :string, null: false
      add :payload, :text, null: false
      add :response, :text
      add :callback_payload, :text
      add :result, :string
      add :sent_at, :naive_datetime_usec
      add :completed_at, :naive_datetime_usec
      add :duration_ms, :integer

      timestamps inserted_at: :created_at
    end

    create index(:requests, [:tracking_id])
  end
end
