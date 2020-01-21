defmodule Uzi.RequestSender do
  alias Uzi.Requests.{Producer, CreateComplianceCheck}

  def create_compliance_check(params) do
    params
    |> Uzi.Requests.Info.new()
    |> Producer.run_async(CreateComplianceCheck)
  end
end
