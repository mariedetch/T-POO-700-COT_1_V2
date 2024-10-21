defmodule TimeManagement.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :manager_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :name, :string, null: false
      add :description, :string

      add :deleted_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end
  end
end
