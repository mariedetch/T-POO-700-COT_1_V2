defmodule TimeManagement.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TimeManagement.Repo

  alias TimeManagement.Teams.Team
  alias TimeManagement.UserContext
  alias TimeManagement.UserContext.User

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams(%User{} = authUser, page \\ 1, page_size \\ 10) do
    query =
      from(t in Team,
        where: is_nil(t.deleted_at),
        order_by: [asc: t.inserted_at]
      )

    query = apply_role_filter(query, authUser)
    teams =
      query
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    teams =
      if authUser.role == :GENERAL_MANAGER do
        Repo.preload(teams, :manager)
      else
        teams
      end

    total_count = count_teams(authUser)

    {teams, total_count}
  end

  defp count_teams(%User{} = authUser) do
    query =
      from(t in Team,
        where: is_nil(t.deleted_at)
      )

    query = apply_role_filter(query, authUser)

    Repo.aggregate(query, :count, :id)
  end

  defp apply_role_filter(query, %User{role: :MANAGER, id: manager_id}) do
    from(t in query, where: t.manager_id == ^manager_id)
  end

  defp apply_role_filter(query, _authUser) do
    query
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id) do
    Team
    |> where([t], is_nil(t.deleted_at))
    |> Repo.get!(id)
  end

  def is_deleted?(%Team{deleted_at: nil}), do: false
  def is_deleted?(%Team{}), do: true

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(%User{} = authUser, attrs \\ %{}) do
    manager = check_manager(authUser, attrs)

    %Team{}
    |> Team.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:created_by, authUser)
    |> Ecto.Changeset.put_assoc(:manager, manager)
    |> Repo.insert()
  end

  def check_manager(auth_user, attrs) do
    case auth_user.role do
      :MANAGER ->
        auth_user

      _ ->
        case Map.fetch(attrs, "manager_id") do
          {:ok, manager_id} ->
            if Ecto.UUID.cast(manager_id) == :error do
              raise ArgumentError, "Invalid manager_id format: must be a valid UUID"
            end

            manager = UserContext.get_user!(manager_id)

            if manager.role == :MANAGER do
              manager
            else
              raise ArgumentError, "User with manager_id is not a manager"
            end

          :error ->
            raise ArgumentError, "manager_id is required if user is not a manager"
        end
    end
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  def soft_delete_team(%Team{} = team) do
    team
    |> Ecto.Changeset.change(%{deleted_at: DateTime.truncate(DateTime.utc_now(), :second)})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end
end
