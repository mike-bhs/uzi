defmodule Uzi.RequestSender do
  def create_compliance_check(params) do
    Uzi.Requests.Tss.create_compliance_check(params)
  end
end
