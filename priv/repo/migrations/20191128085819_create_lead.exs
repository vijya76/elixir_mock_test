defmodule TestTask.Repo.Migrations.CreateLead do
  use Ecto.Migration

  def change do
    create table(:leads) do
      add :name, :string
      add :status, :string, default: "incomplete"
      timestamps()
    end
  end
end
