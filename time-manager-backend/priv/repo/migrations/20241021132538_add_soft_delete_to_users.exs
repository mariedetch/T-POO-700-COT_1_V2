defmodule TimeManagement.Repo.Migrations.AddSoftDeleteToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :deleted_at, :utc_datetime
    end
  end
end
