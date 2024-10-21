defmodule TimeManagement.Members.Member do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "members" do
    belongs_to :team, TimeManagement.Teams.Team
    belongs_to :user, TimeManagement.UserContext.User
    belongs_to :added_by, TimeManagement.UserContext.User

    field :deleted_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:team_id, :user_id, :added_by_id, :deleted_at])
    |> validate_required([:team_id, :user_id, :added_by_id])
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:added_by_id)
  end
end
