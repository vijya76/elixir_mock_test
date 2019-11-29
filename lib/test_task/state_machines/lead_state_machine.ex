defmodule TestTask.LeadStateMachine do
  alias TestTask.Lead
  use Machinery,
    field: :status,
    states: ["incomplete", "pending", "live"],
    transitions: %{
      "incomplete" => "pending",
      "pending" => ["live", "error"]
    }

  def persist(struct, next_state) do
    {:ok, lead} = Lead.update_lead(struct, %{status: next_state})
    lead
  end
end