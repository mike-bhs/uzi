defmodule UziWeb.Endpoint do
  require Logger

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json, :multipart, :urlencoded], json_decoder: Jason)
  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    config = Application.get_env(:uzi, __MODULE__)
    Logger.info("Starting server at http://localhost:#{config[:port]}/")

    Plug.Cowboy.http(__MODULE__, [], config)
  end

  get "/status.json" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: :ok}))
  end

  # format
  # {
  #     "url": "some url",
  #     "request_per_second_count": "20",
  #     "duration_sec": "2",
  #     "payload": {JSON}
  # }
  post "/send_requests" do
    Uzi.RequestSender.create_compliance_check(conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{message: "requests were sent"}))
  end

  post "/transaction_screening/:id/complete" do
    conn = put_resp_content_type(conn, "application/json")

    Uzi.Callbacks.Tss.complete_screening(conn.params)

    conn
    |> send_resp(200, Jason.encode!(%{status: :success}))
  end

  match _ do
    send_resp(conn, 404, "Requested page not found")
  end
end
