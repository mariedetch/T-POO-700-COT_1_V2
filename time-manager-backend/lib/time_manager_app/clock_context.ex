defmodule TimeManagement.ClockContext do
  @moduledoc """
  The ClockContext context.
  """

  import Ecto.Query, warn: false
  alias TimeManagement.Repo

  alias TimeManagement.UserContext.User
  alias TimeManagement.ClockContext.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Returns the list of clocks according to the selected user.

  ## Examples

      iex> list_clocks_by_user(%User{})
      [%Clock{}, ...]

  """
  def list_clocks_by_user(%User{} = user) do
    Repo.all(
      from clock in Clock,
      where: clock.user_id == ^user.id,
      order_by: [desc: clock.inserted_at]
    )
  end

  @doc """
  Returns the latest clock for a user.
  """
  def get_latest_clock_by_user(user_id) do
    case find_latest_clock_by_user(user_id) do
      nil ->
        {:error, :not_found}

      clock ->
        {:ok, clock}
    end
  end

<<<<<<< HEAD

=======
  
>>>>>>> 45a7e11 (chore: mailer)
  def find_latest_clock_by_user(user_id) do
    query = Ecto.Query.from(clock in Clock,
      where: clock.user_id == ^user_id,
      order_by: [desc: clock.inserted_at],
      limit: 1)
    Repo.one(query)
  end

  @doc """
  Clock in or clock out
  """
  def clock_in_or_out(%User{} = user) do
    lastestClock = find_latest_clock_by_user(user.id)
<<<<<<< HEAD
    current_time = DateTime.utc_now()

=======
>>>>>>> 45a7e11 (chore: mailer)
    if lastestClock == nil do
      %Clock{}
      |> Clock.changeset(%{time: DateTime.add(current_time, 3600), status: true})
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()
    else
      %Clock{}
      |> Clock.changeset(%{time: DateTime.add(current_time, 3600), status: !lastestClock.status})
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()
    end
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  def list_clocks_grouped_by_day(user_id) do
    clocks = from(c in Clock, where: c.user_id == ^user_id, order_by: [asc: c.time])
    |> Repo.all()

    clocks
    |> Enum.group_by(fn clock -> NaiveDateTime.to_date(clock.time) end)
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end
end
