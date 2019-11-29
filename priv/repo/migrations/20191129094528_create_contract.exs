defmodule TestTask.Repo.Migrations.CreateContract do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :status, :string, default: "idle"
      add :lead_id, references(:leads, on_delete: :delete_all)     
      timestamps()
    end
  end
end
