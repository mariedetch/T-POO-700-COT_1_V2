defmodule TimeManagement.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagement.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        manager_id: "some manager_id",
        name: "some name",
        number: 42
      })
      |> TimeManagement.Teams.create_team()

    team
  end
end
