defmodule TimeManagementWeb.TeamController do
  use TimeManagementWeb, :controller

  alias TimeManagement.Teams
  alias TimeManagement.Teams.Team

  action_fallback TimeManagementWeb.FallbackController
  plug TimeManagementWeb.Plugs.TeamsAuthorizeAccess

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = Map.get(params, "per_page", "10") |> String.to_integer()

    {teams, total_count} = Teams.list_teams(conn.assigns.current_user, page, per_page)

    render(conn, :index, teams: teams, total_count: total_count, page: page, per_page: per_page)
  end

  def create(conn, %{"team" => team_params}) do
    current_user = conn.assigns.current_user
    with {:ok, %Team{} = team} <- Teams.create_team(current_user, team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.soft_delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end