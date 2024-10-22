defmodule TimeManagement.Repo.Migrations.AddActivatedAtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :activated_at, :utc_datetime
      remove :matricule
    end
  end
end
