defmodule Uzi.Callbacks.CreateComplianceCheck do
  alias Uzi.Models.Request

  def complete(%{"id" => tracking_id, "status" => result} = params) do
    completed_at = NaiveDateTime.utc_now()
    req = Request.find_by_tracking_id(tracking_id)
    duration_ms = NaiveDateTime.diff(completed_at, req.sent_at, :millisecond)

    Request.mark_completed(req, %{
      callback_payload: inspect(params),
      result: result,
      completed_at: completed_at,
      duration_ms: duration_ms
    })
  end
end
