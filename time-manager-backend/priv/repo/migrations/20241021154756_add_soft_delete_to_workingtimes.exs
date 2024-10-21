defmodule TimeManagement.Repo.Migrations.AddSoftDeleteToWorkingtimes do
  use Ecto.Migration

  def change do
    alter table(:workingtimes) do
      add :deleted_at, :utc_datetime
    end
  end
end
