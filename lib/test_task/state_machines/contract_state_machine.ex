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
end