defmodule Uzi.Requests.Tss do
  alias Uzi.Requests.Tss.CreateComplianceCheck

  def create_compliance_check(%{
        "tracking_id" => tracking_id,
        "target_url" => target_url,
        "request_per_second_count" => req_per_sec_count,
        "payload" => payload
      }) do
    CreateComplianceCheck.run_async(target_url, tracking_id, req_per_sec_count, payload)
  end
end
