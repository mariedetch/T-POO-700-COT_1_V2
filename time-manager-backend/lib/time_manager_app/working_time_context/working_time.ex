defmodule TimeManagement.WorkingTimeContext.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    belongs_to :user, TimeManagement.UserContext.User
    belongs_to :team,  TimeManagement.Teams.Team

    field :deleted_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end
