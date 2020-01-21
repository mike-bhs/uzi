defmodule Uzi.Requests.Producer do
  require Logger

  def run_async(req_info, req_module) do
    {:ok, _pid} = Task.start(__MODULE__, :run, [req_info, req_module])

    :ok
  end

  def run(req_info, req_module) do
    if req_info.iterations_count <= 0 do
      Logger.info("Successfully sent all requests to #{req_info.url}")
    else
      send_req_recursive(req_info, req_module)

      Process.sleep(req_info.timeout_millisec)

      req_info
      |> decrement_iterations_count()
      |> run(req_module)
    end
  end

  defp send_req_recursive(req_info, req_module) do
    if req_info.requests_count > 0 do
      {:ok, _pid} = Task.start(req_module, :send_request, [req_info.url, req_info.payload])

      req_info
      |> decrement_requests_count()
      |> send_req_recursive(req_module)
    end
  end

  defp decrement_iterations_count(req_info), do: %{req_info | iterations_count: req_info.iterations_count - 1}
  defp decrement_requests_count(req_info), do: %{req_info | requests_count: req_info.requests_count - 1}
end
