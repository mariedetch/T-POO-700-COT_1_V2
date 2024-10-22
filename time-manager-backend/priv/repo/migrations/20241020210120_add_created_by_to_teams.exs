defmodule TimeManagement.Repo.Migrations.AddCreatedByToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :created_by_id, references(:users, on_delete: :nothing, type: :binary_id)
    end
  end
end
