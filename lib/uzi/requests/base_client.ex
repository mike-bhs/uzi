defmodule Uzi.Requests.BaseClient do
  defmacro __using__(_opts \\ []) do
    quote do
      use Tesla
      adapter Tesla.Adapter.Hackney

      plug Tesla.Middleware.FormUrlencoded
      plug Tesla.Middleware.DecodeJson
      plug Tesla.Middleware.Logger
      plug Tesla.Middleware.Timeout, Application.get_env(:uzi, :outgoing_requests) |> Keyword.get(:timeout_millisec)
      plug Uzi.Requests.BaseClient.ErrorHandlerMiddleware
    end
  end

  defmodule ErrorHandlerMiddleware do
    @behaviour Tesla.Middleware

    @impl true
    def call(env, next, _opts) do
      case Tesla.run(env, next) do
        {:ok, %{body: %{"status" => "failed"}} = env} ->
          {:error, env}

        {:ok, %{body: %{"status" => "error"}} = env} ->
          {:error, env}

        {:ok, %{status: 200} = env} ->
          {:ok, env}

        {:ok, %{status: 201} = env} ->
          {:ok, env}

        {:ok, env} ->
          {:error, env}

        error ->
          error
      end
    end
  end
end
