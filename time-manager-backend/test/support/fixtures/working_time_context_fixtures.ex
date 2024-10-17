defmodule TimeManagement.WorkingTimeContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagement.WorkingTimeContext` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id]
    import TimeManagement.UserContext
    user = get_user!(user_id)
    {:ok, working_time} =
      TimeManagement.WorkingTimeContext.create_working_time(user, attrs |> Enum.into(%{
        user_id: user_id,
        end: ~N[2024-10-07 15:36:00],
        start: ~N[2024-10-07 15:36:00],
      }))

    working_time
  end
end
