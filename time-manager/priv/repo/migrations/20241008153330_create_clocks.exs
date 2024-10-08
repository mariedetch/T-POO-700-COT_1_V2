defmodule TimeManagement.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :time, :naive_datetime, null: false, default: fragment("CURRENT_TIMESTAMP")
      add :status, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:clocks, [:user_id])
  end
end
