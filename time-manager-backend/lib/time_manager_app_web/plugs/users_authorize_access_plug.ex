defmodule TimeManagementWeb.Plugs.UsersAuthorizeAccess do
  use TimeManagementWeb, :controller

  import Plug.Conn
  alias TimeManagement.UserContext.User
  alias TimeManagement.Repo

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    if conn.request_path == "/api/users" and !is_authorized_for_user_list?(user) do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Access forbidden: You are not authorized to view this list of users."})
      |> halt()
    end

    case conn.params do
      %{"id" => user_id} ->
        if !is_authorized_for_user_action?(user, user_id) do
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Access forbidden: You are not authorized to perform this action on the user."})
          |> halt()
        end
      _ -> conn
    end

    conn
  end

  defp is_authorized_for_user_list?(%User{role: :MANAGER}), do: true
  defp is_authorized_for_user_list?(%User{role: :GENERAL_MANAGER}), do: true
  defp is_authorized_for_user_list?(_), do: false

  defp is_authorized_for_user_action?(%User{role: :GENERAL_MANAGER}, _user_id), do: true
  defp is_authorized_for_user_action?(%User{id: userID}, user_id) do
    case User |> Repo.get(user_id) do
      %User{id: ^userID} -> true
      _ -> false
    end
  end
  defp is_authorized_for_user_action?(_, _), do: false
end
