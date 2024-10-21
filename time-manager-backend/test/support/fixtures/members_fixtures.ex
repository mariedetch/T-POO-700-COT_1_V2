defmodule TimeManagement.MembersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagement.Members` context.
  """

  @doc """
  Generate a member.
  """
  def member_fixture(attrs \\ %{}) do
    {:ok, member} =
      attrs
      |> Enum.into(%{
        team_id: "some team_id",
        user_id: "some user_id"
      })
      |> TimeManagement.Members.create_member()

    member
  end
end
