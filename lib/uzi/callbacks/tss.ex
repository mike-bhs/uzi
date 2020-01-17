defmodule Uzi.Callbacks.Tss do
  alias Uzi.Models.ComplianceCheckRequest

  def complete_screening(%{"id" => tracking_id, "status" => result} = params) do
    req = ComplianceCheckRequest.get_by_tracking_id(tracking_id)
    completed_at = NaiveDateTime.utc_now()
    duration_ms = NaiveDateTime.diffcompleted_at, req.sent_at, :millisecond)

    %{
      state: "completed",
      response: params,
      screening_result: result,
      completed_at: completed_at,
      duration_ms: duration_ms
    }
    |> ComplianceCheckRequest.mark_completed()
  end
end
