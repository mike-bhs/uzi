defmodule Uzi.Callbacks.Tss do
  alias Uzi.Models.ComplianceCheckRequest

  def complete_screening(%{"id" => tracking_id, "status" => result}) do
    completed_at = NaiveDateTime.utc_now()
    req = ComplianceCheckRequest.find_by_tracking_id(tracking_id)
    duration_ms = NaiveDateTime.diff(completed_at, req.sent_at, :millisecond)


    ComplianceCheckRequest.mark_completed(req, %{
      screening_result: result,
      completed_at: completed_at,
      duration_ms: duration_ms
    })
  end
end
