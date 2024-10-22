defmodule TimeManagementWeb.Plugs.WorkingtimesAuthorizeAccess do
  use TimeManagementWeb, :controller

  import Plug.Conn
  alias TimeManagement.UserContext.User
  alias TimeManagement.WorkingTimeContext.WorkingTime
  alias TimeManagement.Repo

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    if conn.request_path == "/api/workingtimes" and !is_authorized_for_workingtime_list?(user) do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Access forbidden: You are not authorized to view this list of working times."})
      |> halt()
    end

    case conn.params do
      %{"id" => workingtime_id} ->
        if !is_authorized_for_workingtime_action?(user, workingtime_id) do
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Access forbidden: You are not authorized to perform this action on the team."})
          |> halt()
        end
      _ -> conn
    end

    conn
  end

  defp is_authorized_for_workingtime_list?(%User{role: :MANAGER}), do: true
  defp is_authorized_for_workingtime_list?(%User{role: :GENERAL_MANAGER}), do: true
  defp is_authorized_for_workingtime_list?(_), do: false

  defp is_authorized_for_workingtime_action?(%User{role: :GENERAL_MANAGER}, _workingtime_id), do: true
  defp is_authorized_for_workingtime_action?(%User{id: user_id}, workingtime_id) do
    case WorkingTime |> Repo.get(workingtime_id) do
      %WorkingTime{user_id: ^user_id} -> true
      _ -> false
    end
  end
  defp is_authorized_for_workingtime_action?(_, _), do: false
end
