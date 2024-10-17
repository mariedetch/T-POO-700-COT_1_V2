defmodule TimeManagement.ClockContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagement.ClockContext` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    user_id = attrs[:user_id]
    IO.inspect("aaaaaaaaa #{user_id} tchieeee")
    {:ok, clock} =
      TimeManagement.ClockContext.create_clock(attrs |> Enum.into(%{
        user_id: user_id,
        status: true,
        time: ~N[2024-10-07 15:33:00]
      }))

    clock
  end
end
