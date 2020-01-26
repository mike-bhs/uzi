defmodule Uzi.Requests.Producer do
  require Logger

  def receive_messages() do
    receive do
      {:send_request, req_info, req_module, req_count} ->
        if req_count > 0 do
          {:ok, _pid} = Task.start(req_module, :send_request, [req_info.url, req_info.payload])
          message = {:send_request, req_info, req_module, req_count - 1}
          Process.send_after(self(), message, req_info.timeout_between_requests_millisec)

          receive_messages()
        else
          Logger.info("Current thread successfully sent all requests")
        end

      message ->
        Logger.error("Received unexpected message #{inspect(message)}")
        receive_messages()
    end
  end

  def run(req_info, req_module) do
    Enum.each(1..req_info.threads_count, fn _ ->
      {:ok, pid} = Task.start(__MODULE__, :receive_messages, [])

      send(pid, {:send_request, req_info, req_module, req_info.requests_per_thread_count})
    end)
  end
end
