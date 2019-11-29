defmodule TestTask.Contract do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias TestTask.Repo
  alias TestTask.Contract

  schema "contracts" do
    field :status, :string, default: "idle"

    belongs_to :lead, TestTask.Lead
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :lead_id])
    |> validate_required([:status])
    |> assoc_constraint(:lead)
  end

  def get_contract!(id) do
    Repo.get!(Contract, id)
    |> Repo.preload([:lead])
  end

  def create_contract(attrs \\ %{}) do
    %Contract{}
    |> Contract.changeset(attrs)
    |> Repo.insert()
  end

  def update_contract(%Contract{} = contract, attrs) do
    contract
    |> Contract.changeset(attrs)
    |> Repo.update()
  end

  def send_contract(contract) do
    Machinery.transition_to(contract, TestTask.ContractStateMachine, "sent")
  end

  def sign_contract(contract) do
    Machinery.transition_to(contract, TestTask.ContractStateMachine, "signed")
  end
end
