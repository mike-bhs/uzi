defmodule Uzi.Requests.CreateComplianceCheck do
  require Logger

  use Uzi.Requests.BaseClient
  alias Uzi.Models.Request

  def send_request(url, payload) do
    req_payload = merge_dynamic_fields(payload)
    req_record = Request.create(url, payload, req_payload["source_id"])

    Logger.info("Sending request to #{url} ...")
    case post(url, req_payload, []) do
      {:ok, %{body: response}} ->
        Request.mark_pending(req_record, response)

      {:error, error} ->
        Request.mark_error(req_record, error)
    end
  end

  defp merge_dynamic_fields(payload) do
    host = Application.get_env(:uzi, :callbacks) |> Keyword.get(:reply_to_host)
    port = Application.get_env(:uzi, UziWeb.Endpoint) |> Keyword.get(:port)

    source_id = Ecto.UUID.generate()
    transaction_id = Ecto.UUID.generate()

    dynamic_data = %{
      "source_id" => source_id,
      "transaction_id" => transaction_id,
      "short_reference" => generate_short_reference(),
      "reply_to" => "http://#{host}:#{port}/transaction_screening/#{source_id}/complete"
    }

    Map.merge(payload, dynamic_data)
  end

  defp generate_short_reference() do
    current_date = Date.utc_today() |> Date.to_iso8601(:basic)
    "IF-#{current_date}-#{short_ref_random()}"
  end

  defp short_ref_random() do
    min = String.to_integer("100000", 36)
    max = String.to_integer("ZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end
end
