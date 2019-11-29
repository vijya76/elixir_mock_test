defmodule TestTask.Repo.Migrations.CreatePaymentDetail do
  use Ecto.Migration

  def change do
    create table(:payment_details) do
      add :stripe_card_id, :string
      add :stripe_customer_id, :string
      add :exp_month, :integer
      add :exp_year, :integer
      add :lead_id, references(:leads, on_delete: :delete_all) 
      
      timestamps()
    end
  end
end
