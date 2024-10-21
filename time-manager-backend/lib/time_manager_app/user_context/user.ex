defmodule TimeManagement.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :tel, :string
    field :password, :string, redact: true
    field :role, Ecto.Enum, values: [:GENERAL_MANAGER, :MANAGER, :EMPLOYEE]
    has_many :clocks, TimeManagement.ClockContext.Clock
    has_many :workingtimes, TimeManagement.WorkingTimeContext.WorkingTime

    field :deleted_at, :utc_datetime
    field :activated_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:matricule, :firstname, :lastname, :email, :tel, :password, :role, :deleted_at])
    |> validate_required([:matricule, :firstname, :lastname, :email, :role])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:tel)
    |> validate_length(:password, min: 8)
  end

  def password_reset_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])/,
        message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character"
      )
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if changeset.valid? do
      change(changeset, password: Bcrypt.hash_pwd_salt(get_change(changeset, :password)))
    else
      changeset
    end
  end

end
