defmodule Uzi.Requests.Tss do
  alias Uzi.Requests.Tss.CreateComplianceCheck

  def create_compliance_check(%{
        "url" => url,
        "request_per_second_count" => req_per_sec_count,
        "attempts_count" => attempts_count,
        "payload" => payload
      }) do
    CreateComplianceCheck.run_async(
      url,
      String.to_integer(req_per_sec_count),
      String.to_integer(attempts_count),
      payload
    )
  end
end
