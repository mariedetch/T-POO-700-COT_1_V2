defmodule TimeManagement.Members do
  @moduledoc """
  The Members context.
  """

  import Ecto.Query, warn: false
  alias TimeManagement.Repo

  alias TimeManagement.Members.Member
  alias TimeManagement.Teams

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]


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

  """
  def list_members(team_id, page \\ 1, page_size \\ 10) do
    query =
      from(t in Member,
        where: is_nil(t.deleted_at),
        where: t.team_id == ^team_id,
        order_by: [asc: t.inserted_at]
      )

    members =
      query
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    members = Repo.preload(members, :user)
    total_count = Repo.aggregate(query, :count, :id)

    {members, total_count}
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: Repo.get!(Member, id)

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def add_members_to_team(team_id, user_ids, added_by_id) do
    _team = Teams.get_team!(team_id)
    existing_user_ids =
      Repo.all(from m in Member, where: m.team_id == ^team_id, select: m.user_id)

    new_user_ids = Enum.filter(user_ids, fn user_id ->
      not Enum.member?(existing_user_ids, user_id)
    end)

    if new_user_ids == [] do
      {:error, "All members already exist in the team"}
    else
      members = for user_id <- user_ids do
        %Member{}
        |> Member.changeset(%{
          team_id: team_id,
          user_id: user_id,
          added_by_id: added_by_id
        })
        |> Repo.insert()
      end

      {successful_inserts, failed_inserts} =
        Enum.split_with(members, fn
          {:ok, _member} -> true
          _ -> false
        end)

      if failed_inserts == [] do
        {:ok, successful_inserts}
      else
        {:error, failed_inserts}
      end
    end
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  def soft_delete_member(%Member{} = member) do
    member
    |> Ecto.Changeset.change(%{deleted_at: DateTime.truncate(DateTime.utc_now(), :second)})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{data: %Member{}}

  """
  def change_member(%Member{} = member, attrs \\ %{}) do
    Member.changeset(member, attrs)
  end
end
