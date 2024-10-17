defmodule TimeManagement.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :matricule, :integer
      add :firstname, :string
      add :lastname, :string
      add :tel, :string
      add :password, :string
      add :role, :string
      remove :username
    end

    create unique_index(:users, [:matricule])
    create unique_index(:users, [:tel])
    #drop unique_index(:users, [:username])
  end
end
