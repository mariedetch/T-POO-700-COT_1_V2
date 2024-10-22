defmodule TimeManagement.WorkingTimeContext do
  @moduledoc """
  The WorkingTimeContext context.
  """

  import Ecto.Query, warn: false
  alias TimeManagement.Repo

  alias TimeManagement.UserContext.User
  alias TimeManagement.WorkingTimeContext.WorkingTime
  alias TimeManagement.Teams.Team
  alias TimeManagement.Members.Member

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_by_id(user_id, start_date, end_date) do
    Repo.all(from w in WorkingTime, where: w.user_id == ^user_id and w.start >= ^start_date and w.end <= ^end_date)
    |> Repo.preload(:user)
  end

  def list_workingtimes(user_id) do
    Repo.all(from w in WorkingTime, where: w.user_id == ^user_id)
    |> Repo.preload(:user)
  end

  def list_workingtime(%User{} = authUser) do
    query =
      from(t in Workingtime,
        where: is_nil(t.deleted_at),
        order_by: [asc: t.inserted_at]
      )

    query = apply_user_filter(query, authUser)
    workingtime =
      query
      |> Repo.all()

    {workingtime}
  end

  def list_workingtime_by_team(%User{} = authUser, %Team{} = team) do
    query =
      from(t in Workingtime,
        where: is_nil(t.deleted_at),
        order_by: [asc: t.inserted_at]
      )

    query = apply_user_filter(query, authUser)
    query = apply_team_filter(query, team)
    workingtime =
      query
      |> Repo.all()

    {workingtime}
  end

  defp apply_user_filter(query, %User{id: user_id}) do
    from(t in query, where: t.user_id == ^user_id)
  end

  defp apply_user_filter(query, _authUser) do
    query
  end

  defp apply_team_filter(query, %Team{id: team_id}) do
    from(t in query, where: t.team_id == ^team_id)
  end

  defp apply_team_filter(query, _team) do
    query
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """

  def get_working_time!(id, user_id) do
    Repo.get!(WorkingTime, id, user_id: user_id)
    |> Repo.preload(:user)
  end

  #######  Mon nouveau get_working_time indépendant du user =======================
  def get_working_time_2!(id) do
    Repo.get!(WorkingTime, id)
  end

  def get_working_time!(id) do
    Repo.get!(WorkingTime, id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(current_user, team, user, attrs \\ %{}) do
    case cerrent_user.role do
      :MANAGER ->
        %WorkingTime{}
        |> WorkingTime.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:user, user)
        |> Ecto.Changeset.put_assoc(:team, team)
        |> Repo.insert()
      :GENERAL_MANAGER ->
        %WorkingTime{}
        |> WorkingTime.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:user, user)
        |> Ecto.Changeset.put_assoc(:team, team)
        |> Repo.insert()
      _ ->
        {:error, "You're not allowed to create that workingtime"}
    end
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:team, team)
    |> Repo.insert()
  end

  def create_working_times_for_users(%Team{id: team_id} = team, users, attrs \\ %{}) do
    IO.inspect(users)

    case all_users_belong_to_team?(team_id, users) do
      true ->
        users
        |> Enum.map(fn user ->
          case create_working_time(team, user, attrs) do
            nil -> {:error, "User not found"}
            user -> {:ok, user}
          end
        end)

      false ->
        {:error, "Not all users belong to the same team"}
    end
  end

  defp all_users_belong_to_team?(team_id, users) do
    users
    |> Enum.all?(fn user ->
      query = from(m in Member,
        where: m.user_id == ^user.id and m.team_id == ^team_id,
        select: m.id
      )
      Repo.exists?(query)
    end)
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
