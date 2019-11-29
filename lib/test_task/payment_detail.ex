defmodule TestTask.PaymentDetail do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias TestTask.Repo
  alias TestTask.PaymentDetail
  alias TestTask.Lead

  schema "payment_details" do
    field :stripe_card_id, :string
    field :stripe_customer_id, :string
    field :exp_month, :integer
    field :exp_year, :integer

    belongs_to :lead, TestTask.Lead
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:stripe_card_id, :stripe_customer_id, :exp_month, :exp_year, :lead_id])
    |> assoc_constraint(:lead)
  end

  def get_contract!(id) do
    Repo.get!(PaymentDetail, id)
    |> preload_payment_detail
  end

  def create_payment_detail(lead_id) do
    attrs = create_card(lead_id)
    payment_detail =  %PaymentDetail{}
                      |> PaymentDetail.changeset(attrs)
                      |> Repo.insert()

    case payment_detail do
      {:ok, payment_detail} -> change_lead_status(payment_detail)
    end

    payment_detail
  end

  def change_lead_status(payment_detail) do
    lead = preload_payment_detail(payment_detail).lead

    if !Blankable.blank?(lead.information) && !Blankable.blank?(lead.contract) && lead.contract.status == "signed" do
      Lead.lead_transition_to(lead, "pending")
    end
  end

  def preload_payment_detail(payment_detail) do
    payment_detail
    |> Repo.preload([lead: [:contract, :information]])
  end

  def create_card(lead_id) do
    %{stripe_card_id: "card_id_123", stripe_customer_id: "cust123", exp_month: 5, exp_year: 2024, lead_id: lead_id}
  end
end
