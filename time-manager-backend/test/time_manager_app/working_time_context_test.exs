defmodule TimeManagement.WorkingTimeContextTest do
  use TimeManagement.DataCase, async: true

  alias TimeManagement.WorkingTimeContext
  alias TimeManagement.WorkingTimeContext.WorkingTime
  alias TimeManagement.UserContext.User
  alias TimeManagement.Teams.Team

  @valid_attrs %{start: ~N[2023-01-01 09:00:00], end: ~N[2023-01-01 17:00:00]}
  @invalid_attrs %{start: nil, end: nil}

  setup do
    # Créez un utilisateur et une équipe pour les tests
    user = %User{lastname: "User", firstname: "User",  email: "test@example.com"} |> Repo.insert!()
    team = %Team{name: "Test Team"} |> Repo.insert!()

    {:ok, user: user, team: team}
  end

  test "create_working_time/4 with valid data", %{user: user, team: team} do
    assert {:ok, %WorkingTime{} = working_time} =
             WorkingTimeContext.create_working_time(user, team, user, @valid_attrs)

    assert working_time.start == @valid_attrs.start
    assert working_time.end == @valid_attrs.end
    assert working_time.user_id == user.id
    assert working_time.team_id == team.id
  end

  # Ajoutez d'autres tests pour les fonctions restantes...
end
