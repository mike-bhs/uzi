defmodule Uzi.Requests.BaseClient do
  defmacro __using__(_opts \\ []) do
    quote do
      use Tesla
      adapter Tesla.Adapter.Hackney

      plug Tesla.Middleware.FormUrlencoded
      plug Tesla.Middleware.DecodeJson
      plug Tesla.Middleware.Logger
      # interrupt request by timeout if it took more than 6 sec
      plug Tesla.Middleware.Timeout, timeout: 6_000
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
