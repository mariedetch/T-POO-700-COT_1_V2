defmodule TimeManagement.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :added_by_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      add :deleted_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end
  end
end
