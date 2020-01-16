defmodule Uzi.Requests.Tss.CreateComplianceCheck do
  require Logger

  def run_async(target_url, tracking_id, requests_count, payload) do
    spawn(fn ->
      run(target_url, tracking_id, requests_count, payload)
    end)
  end

  defp run(target_url, tracking_id, requests_count, payload) do
    if requests_count == 0 do
      Logger.info("Successfully sent all requests to #{target_url}")
    else
      spawn(fn ->
        send_request(target_url, tracking_id, payload)
      end)

      Process.sleep(1_000)
      run(target_url, tracking_id, requests_count - 1, payload)
    end
  end

  defp send_request(target_url, tracking_id, payload) do
    
  end
end
