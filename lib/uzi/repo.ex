defmodule Uzi.Repo do
  use Ecto.Repo,
    otp_app: :uzi,
    adapter: Ecto.Adapters.MyXQL
end
