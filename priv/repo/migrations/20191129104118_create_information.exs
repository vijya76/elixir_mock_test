defmodule TestTask.Repo.Migrations.CreateInformation do
  use Ecto.Migration

  def change do
    create table(:informations) do
      add :country, :string
      add :address, :string
      add :lead_id, references(:leads, on_delete: :delete_all) 
      timestamps()
    end
  end
end
