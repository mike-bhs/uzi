defmodule Uzi.Requests.Tss.CreateComplianceCheck do
  require Logger

  use Uzi.Requests.BaseClient
  alias Uzi.Models.ComplianceCheckRequest

  def run_async(target_url, requests_count, attempts_count, payload) do
    spawn(fn ->
      run(target_url, requests_count, attempts_count, payload)
    end)
  end

  defp run(target_url, requests_count, attempts_count, payload) do
    if attempts_count == 0 do
      Logger.info("Successfully sent all requests to #{target_url}")
    else
      (1 .. requests_count) |> Enum.each(fn _ ->
        spawn(fn ->
          send_request(target_url, payload)
        end)
      end)

      Process.sleep(1_000)
      run(target_url, requests_count, attempts_count - 1, payload)
    end
  end

  defp send_request(url, req_payload) do
    req_payload = Map.merge(req_payload, dynamic_fields())
    response = post(url, req_payload, [])

    case response do
      {:ok, %{body: resp_payload}} ->
        save_success_response(url, req_payload, resp_payload)

      {:error, error} ->
        save_error_repsonse(url, req_payload, error)
    end
  end

  defp save_success_response(url, payload, response) do
    %{
      state: "pending",
      tracking_id: payload["source_id"],
      url: url,
      payload: payload,
      response: response,
      sent_at: NaiveDateTime.utc_now(),
    }
    |> ComplianceCheckRequest.create()
  end

  defp save_error_response(url, payload, error) do
    %{
      state: "failed",
      tracking_id: payload["source_id"],
      url: url,
      payload: payload,
      response: error,
      sent_at: NaiveDateTime.utc_now(),
    }
    |> ComplianceCheckRequest.create()
  end

  defp dynamic_fields() do
    %{
      "source_id" => Ecto.UUID.generate()
    }
  end
end
