defmodule Uzi.Requests.Tss.CreateComplianceCheck do
  require Logger

  use Uzi.Requests.BaseClient
  alias Uzi.Models.ComplianceCheckRequest

  def run_async(url, requests_count, attempts_count, payload) do
    spawn(fn ->
      run(url, requests_count, attempts_count, payload)
    end)
  end

  defp run(url, requests_count, attempts_count, payload) do
    if attempts_count == 0 do
      Logger.info("Successfully sent all requests to #{url}")
    else
      (1 .. requests_count) |> Enum.each(fn _ ->
        spawn(fn ->
          send_request(url, payload)
        end)
      end)

      Process.sleep(1_000)
      run(url, requests_count, attempts_count - 1, payload)
    end
  end

  defp send_request(url, req_payload) do
    req_payload = Map.merge(req_payload, dynamic_fields())
    req_record = create_request_record(url, req_payload)
    response = post(url, req_payload, [])

    case response do
      {:ok, %{body: resp_payload}} ->
        ComplianceCheckRequest.mark_pending(req_record, resp_payload)

      {:error, error} ->
        ComplianceCheckRequest.mark_error(req_record, error)
    end
  end

  defp create_request_record(url, payload) do
    %{
      tracking_id: payload["source_id"],
      url: url,
      payload: inspect(payload),
      sent_at: NaiveDateTime.utc_now(),
    }
    |> ComplianceCheckRequest.create()
  end

  defp dynamic_fields() do
    source_id = Ecto.UUID.generate()

    %{
      "source_id" => source_id,
      "reply_to" => "http://192.168.30.174:8081/transaction_screening/#{source_id}/complete"
    }
  end
end
