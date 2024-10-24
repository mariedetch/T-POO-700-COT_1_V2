defmodule TimeManagement.TeamsTest do
  use TimeManagement.DataCase

  alias TimeManagement.Teams

  describe "teams" do
    alias TimeManagement.Teams.Team

    import TimeManagement.TeamsFixtures

    @invalid_attrs %{name: nil, number: nil, manager_id: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end
  end
end
