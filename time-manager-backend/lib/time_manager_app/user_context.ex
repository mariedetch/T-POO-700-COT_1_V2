defmodule TimeManagement.UserContext do
  use Timex
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias TimeManagement.Repo

  alias TimeManagement.UserContext.User

  def get_users_by_search(email \\ nil, firstname \\ nil, lastname \\ nil, matricule \\ nil, role \\ nil) do
    User
    |> where_email_user(email)
    |> where_firstname(firstname)
    |> where_lastname(lastname)
    |> where_matricule(matricule)
    |> where_role(role)
    |> Repo.all()
  end

  defp where_email_user(query, nil), do: query
  defp where_email_user(query, email), do: from(u in query, where: u.email == ^email)

  defp where_lastname(query, nil), do: query
  defp where_lastname(query, lastname), do: from(u in query, where: u.lastname == ^lastname)

  defp where_firstname(query, nil), do: query
  defp where_firstname(query, firstname), do: from(u in query, where: u.firstname == ^firstname)

  defp where_matricule(query, nil), do: query
  defp where_matricule(query, matricule), do: from(u in query, where: u.matricule == ^matricule)

  defp where_role(query, nil), do: query
  defp  where_role(query, role), do: from(u in query, where: u.role == ^role)

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
    Repo.get!(User, id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
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
    Repo.delete(user)
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
end
