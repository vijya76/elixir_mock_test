defmodule TestTask.Information do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias TestTask.Repo
  alias TestTask.Information
  alias TestTask.Lead

  schema "informations" do
    field :country, :string
    field :address, :string

    belongs_to :lead, TestTask.Lead
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:country, :address, :lead_id])
    |> validate_required([:country, :address, :lead_id])
    |> assoc_constraint(:lead)
  end

  def get_information!(id) do
    Repo.get!(Information, id)
    |> preload_information
  end

  def create_information(attrs \\ %{}) do
    information = %Information{}
                   |> Information.changeset(attrs)
                   |> Repo.insert()

    case information do
      {:ok, information} -> change_lead_status(information)
    end

    information
  end

  def change_lead_status(information) do
    lead = preload_information(information).lead

    if !Blankable.blank?(lead.payment_detail) && !Blankable.blank?(lead.contract) && lead.contract.status == "signed" do
      Lead.lead_transition_to(lead, "pending")
    end
  end

  def preload_information(information) do
    information
    |> Repo.preload([lead: [:contract, :payment_detail]])
  end
end
