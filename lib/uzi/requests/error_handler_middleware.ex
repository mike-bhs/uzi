defmodule Uzi.Requests.ErrorHandlerMiddleware do
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
