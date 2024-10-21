defmodule TimeManagementWeb.Plugs.TeamsAuthorizeAccess do
  use TimeManagementWeb, :controller

  import Plug.Conn
  alias TimeManagement.UserContext.User
  alias TimeManagement.Teams.Team
  alias TimeManagement.Repo

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    if conn.request_path == "/api/teams" and !is_authorized_for_team_list?(user) do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Access forbidden: You are not authorized to view this list of teams."})
      |> halt()
    end

    case conn.params do
      %{"id" => team_id} ->
        if !is_authorized_for_team_action?(user, team_id) do
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Access forbidden: You are not authorized to perform this action on the team."})
          |> halt()
        end
      _ -> conn
    end

    conn
  end

  defp is_authorized_for_team_list?(%User{role: :MANAGER}), do: true
  defp is_authorized_for_team_list?(%User{role: :GENERAL_MANAGER}), do: true
  defp is_authorized_for_team_list?(_), do: false

  defp is_authorized_for_team_action?(%User{role: :GENERAL_MANAGER}, _team_id), do: true
  defp is_authorized_for_team_action?(%User{id: user_id}, team_id) do
    case Team |> Repo.get(team_id) do
      %Team{manager_id: ^user_id} -> true
      _ -> false
    end
  end
  defp is_authorized_for_team_action?(_, _), do: false
end
