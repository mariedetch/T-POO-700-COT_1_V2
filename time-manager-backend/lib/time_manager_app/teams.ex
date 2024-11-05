defmodule TimeManagement.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TimeManagement.Repo

  alias TimeManagement.Teams.Team
  alias TimeManagement.Members.Member
  alias TimeManagement.{UserContext, Members}
  alias TimeManagement.UserContext.User

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams(%User{} = authUser, page \\ 1, page_size \\ 10) do
    query = from(t in Team, where: is_nil(t.deleted_at), distinct: true) #

    query =
      case authUser.role do
        :GENERAL_MANAGER -> query
        :MANAGER -> from(t in query, where: t.manager_id == ^authUser.id)
        :EMPLOYEE ->
          from(t in query,
            join: m in Member, on: m.team_id == t.id,
            where: m.user_id == ^authUser.id,
            where: is_nil(m.deleted_at)
          )
      end

    total_count = Repo.aggregate(query, :count, :id)

    teams =
      query
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> count_members_per_team()
      |> Repo.all()

    teams =
      if authUser.role == :MANAGER do
        teams
      else
        for(team <- teams, do: %{
          team: Repo.preload(team.team, :manager),
          member_count: team.member_count
        })
      end

    {teams, total_count}
  end

  defp count_members_per_team(query) do
    from(t in query,
      left_join: m in Member, on: m.team_id == t.id and is_nil(m.deleted_at),
      group_by: [t.id, m.id],
      select: %{team: t, member_count: count(m.id)}
    )
  end

  def list_users_not_in_team(team_id) do
    query =
      from(u in User,
        where: u.role == :EMPLOYEE,
        where: u.id not in subquery(from(m in Member,
          where: m.team_id == ^team_id,
          select: m.user_id
        ))
      )

    Repo.all(query)
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
    user_ids = Map.get(attrs, "user_ids", nil)

    {:ok, team} = %Team{}
      |> Team.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:created_by, authUser)
      |> Ecto.Changeset.put_assoc(:manager, manager)
      |> Repo.insert()

    case user_ids do
      _ ->
        case Members.add_members_to_team(team.id, user_ids, authUser.id) do
          {:ok, _successful_inserts} -> {:ok, team}
          _ -> {:error, team}
        end
    end

    {:ok, team}
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

  def count_members_in_team(team_id) do
    query =
      from(t in Member,
        where: is_nil(t.deleted_at),
        where: t.team_id == ^team_id
      )

    total_count = Repo.aggregate(query, :count, :id)
  end
end
