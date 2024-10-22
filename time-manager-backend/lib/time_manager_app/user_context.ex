defmodule TimeManagement.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias TimeManagement.Repo

  alias TimeManagement.UserContext.User

  def get_users_by_search(%User{} = authUser, page \\ 1, page_size \\ 10, email \\ nil, firstname \\ nil, lastname \\ nil, role \\ nil) do
    query =
      from(t in User,
        where: is_nil(t.deleted_at),
        order_by: [asc: t.inserted_at]
      )

    query = where_email_user(query, email)
    query = where_firstname(query, firstname)
    query = where_lastname(query, lastname)
    query = where_role(query, role)

    users =
      query
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    total_count = count_users()
    {users, total_count}
  end

  defp where_email_user(query, nil), do: query
  defp where_email_user(query, email), do: from(u in query, where: u.email == ^email)

  defp where_lastname(query, nil), do: query
  defp where_lastname(query, lastname), do: from(u in query, where: u.lastname == ^lastname)

  defp where_firstname(query, nil), do: query
  defp where_firstname(query, firstname), do: from(u in query, where: u.firstname == ^firstname)

  defp where_role(query, nil), do: query
  defp  where_role(query, role), do: from(u in query, where: u.role == ^role)

  defp count_users() do
    query =
      from(t in User,
        where: is_nil(t.deleted_at)
      )

    Repo.aggregate(query, :count, :id)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    User
    |> where([t], is_nil(t.deleted_at))
    |> Repo.get!(User, id)
  end

  def is_deleted?(%User{deleted_at: nil}), do: false
  def is_deleted?(%User{}), do: true

  def find_by_email!(email), do: Repo.get_by!(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(%User{} = authUser, attrs \\ %{}) do
    if authUser.role == :GENERAL_MANAGER do
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    user
    |> Ecto.Changeset.change(%{deleted_at: DateTime.truncate(DateTime.utc_now(), :second)})
    |> Repo.update()
  end

  @doc """
  Promote a user.

  ## Examples

      iex> promote_user(user)
      {:ok, %User{}}

      iex> promote_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def promote_user(%User{role: :EMPLOYEE} = user) do
    user
    |> User.changeset(%{role: :MANAGER})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, password) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :user_not_found}
      user ->
        if Bcrypt.verify_pass(password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_password}
        end
    end
  end

  def reset_password(user_id, new_password) do
    user = Repo.get(User, user_id)
    user
    |> User.changeset(%{password: new_password})
    |> Repo.update()
  end
end
