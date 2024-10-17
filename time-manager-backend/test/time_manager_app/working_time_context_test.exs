defmodule TimeManagement.WorkingTimeContextTest do
  use TimeManagement.DataCase

  alias TimeManagement.WorkingTimeContext

  describe "workingtimes" do
    alias TimeManagement.WorkingTimeContext.WorkingTime

    import TimeManagement.WorkingTimeContextFixtures
    import TimeManagement.UserContextFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/1 returns all user workingtimes" do
      user = user_fixture()
      working_time = working_time_fixture(%{user_id: user.id})
      assert WorkingTimeContext.list_workingtimes(user.id) == [working_time]
    end

    test "get_working_time!/2 returns the working_time with given id" do
      user = user_fixture()
      working_time = working_time_fixture(%{user_id: user.id})
      assert WorkingTimeContext.get_working_time!(working_time.id, user.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2024-10-07 15:36:00], end: ~N[2024-10-07 15:36:00]}
      user = user_fixture()

      assert {:ok, %WorkingTime{} = working_time} = WorkingTimeContext.create_working_time(user, valid_attrs)
      assert working_time.start == ~N[2024-10-07 15:36:00]
      assert working_time.end == ~N[2024-10-07 15:36:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTimeContext.create_working_time(user, @invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      user = user_fixture()
      working_time = working_time_fixture(%{user_id: user.id})
      update_attrs = %{start: ~N[2024-10-08 15:36:00], end: ~N[2024-10-08 15:36:00]}

      assert {:ok, %WorkingTime{} = working_time} = WorkingTimeContext.update_working_time(working_time, update_attrs)
      assert working_time.start == ~N[2024-10-08 15:36:00]
      assert working_time.end == ~N[2024-10-08 15:36:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      user = user_fixture()
      working_time = working_time_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = WorkingTimeContext.update_working_time(working_time, @invalid_attrs)
      assert working_time == WorkingTimeContext.get_working_time!(working_time.id, user.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      user = user_fixture()
      working_time = working_time_fixture(%{user_id: user.id})
      assert {:ok, %WorkingTime{}} = WorkingTimeContext.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> WorkingTimeContext.get_working_time!(working_time.id, user.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      user = user_fixture()
      working_time = working_time_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = WorkingTimeContext.change_working_time(working_time)
    end
  end
end
