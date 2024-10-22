defmodule TimeManagement.Repo.Migrations.AlterWorkingtimes do
  use Ecto.Migration

  def change do
    alter table(:workingtimes) do
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
    end
  end
end
