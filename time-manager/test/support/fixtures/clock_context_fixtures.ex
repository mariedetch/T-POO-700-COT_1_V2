defmodule TimeManagement.ClockContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagement.ClockContext` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 15:33:00]
      })
      |> TimeManagement.ClockContext.create_clock()

    clock
  end
end
