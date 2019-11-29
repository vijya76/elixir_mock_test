defmodule TestTask.ContractStateMachine do
  alias TestTask.Contract
  use Machinery,
    field: :status,
    states: ["idle", "sent", "signed"],
    transitions: %{
      "idle" => "sent",
      "sent" => "signed"
    }

  def persist(struct, next_state) do
    {:ok, contract} = Contract.update_contract(struct, %{status: next_state})
    contract
  end

  def after_transition(struct, "signed") do
    lead = TestTask.Lead.preload_lead(struct.lead)
    if !Blankable.blank?(lead.payment_detail) && !Blankable.blank?(lead.information) do
      TestTask.Lead.update_lead(lead, %{status: "pending"})
    end
    
    struct
  end
end