defmodule TimeManagement.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :matricule, :integer
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :tel, :string
    field :password, :string, redact: true
    field :role, Ecto.Enum, values: [:GENERAL_MANAGER, :MANAGER, :EMPLOYEE]
    has_many :clocks, TimeManagement.ClockContext.Clock
    has_many :workingtimes, TimeManagement.WorkingTimeContext.WorkingTime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:matricule, :firstname, :lastname, :email, :tel, :password, :role])
    |> validate_required([:matricule, :firstname, :lastname, :email, :role])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:matricule)
    |> unique_constraint(:tel)
    |> validate_length(:password, min: 8)
    |> validate_length(:matricule, min: 6)
  end

  defp put_password_hash(changeset) do
    if changeset.valid? do
      change(changeset, password: Bcrypt.hash_pwd_salt(get_change(changeset, :password)))
    else
      changeset
    end
  end

end
