defmodule TimeManagement.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teams" do
    field :name, :string
    field :description, :string
    belongs_to :manager, TimeManagement.UserContext.User
    belongs_to :created_by, TimeManagement.UserContext.User
    has_many :workingtimes, TimeManagement.WorkingTimeContext.WorkingTime

    field :deleted_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:description, :name, :deleted_at])
    |> validate_required([:description, :name])
  end
end
