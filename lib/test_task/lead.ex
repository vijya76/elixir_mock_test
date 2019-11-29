defmodule TestTask.Lead do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias TestTask.Repo
  alias TestTask.Lead

  schema "leads" do
    field :status, :string, default: "incomplete"
    field :name, :string

    has_one :contract, TestTask.Contract
    has_one :information, TestTask.Information
    has_one :payment_detail, TestTask.PaymentDetail

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :name])
    |> validate_required([:status])
  end

  def get_lead!(id) do
    Repo.get!(Lead, id)
    |> preload_lead
  end

  def create_lead(attrs \\ %{}) do
    %Lead{}
    |> Lead.changeset(attrs)
    |> Repo.insert()
  end

  def update_lead(%Lead{} = lead, attrs) do
    lead
    |> Lead.changeset(attrs)
    |> Repo.update()
  end

  def preload_lead(lead) do
    lead
    |> Repo.preload([:contract, :information, :payment_detail])
  end

  def force_live(lead) do
    Lead.update_lead(lead, %{status: "live"})
  end

  def ship_welcome_package(lead) do
    status = Enum.random(["error", "live"])
    Machinery.transition_to(lead, TestTask.LeadStateMachine, status)
  end
end
