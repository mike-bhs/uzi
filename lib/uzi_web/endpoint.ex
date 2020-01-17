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

  # params
  # %{
  #   tracking_id: "asdasd",
  #   target_url: "asdasdas",
  #   request_per_second_count: 2,
  #   attemprs_count: 10,
  #   payload: %{}
  # }
  post "/send_requests" do
    Logger.info("Received payload: #{inspect(conn.body_params)}")

    response = Uzi.RequestSender.create_compliance_check(conn.body_params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(response))
  end

  post "/transaction_screening/:id/complete" do
    conn = put_resp_content_type(conn, "application/json")

    case TransactionScreening.complete_screening(conn.body_params) do
      :ok ->
        conn
        |> send_resp(200, Jason.encode!(%{status: :success}))

      {:error, _error} ->
        conn
        |> send_resp(500, Jason.encode!(%{status: :internal_server_error}))
    end
  end

  match _ do
    send_resp(conn, 404, "Requested page not found")
  end
end
