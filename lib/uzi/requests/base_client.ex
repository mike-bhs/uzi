defmodule Uzi.Requests.BaseClient do
  defmacro __using__(opts \\ []) do
    quote do
      use Tesla

      # @retry_config Application.get_env(:funds, :http_retry)

      adapter Tesla.Adapter.Hackney

      # plug Tesla.Middleware.Retry,
      #   delay: @retry_config[:delay],
      #   max_retries: @retry_config[:max_retries],
      #   max_delay: @retry_config[:max_delay],
      #   should_retry: fn
      #     {:ok, %{status: status}} when status in [500, 502] -> true
      #     {:ok, _} -> false
      #     {:error, _} -> true
      #   end

      # plug Tesla.Middleware.BaseUrl, unquote(opts)[:url]
      # plug Tesla.Middleware.Timeout, timeout: 5_000
      plug Tesla.Middleware.FormUrlencoded
      plug Tesla.Middleware.DecodeJson
      plug Tesla.Middleware.Logger
      plug Uzi.Requests.ErrorHandlerMiddleware
    end
  end
end
