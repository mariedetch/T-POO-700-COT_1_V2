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

    if !is_authorized_for_user_action?(user) do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Access forbidden: You are not authorized to perform this action on the user."})
      |> halt()
    end

    conn
  end

  defp is_authorized_for_user_list?(%User{role: :MANAGER}), do: true
  defp is_authorized_for_user_list?(%User{role: :GENERAL_MANAGER}), do: true
  defp is_authorized_for_user_list?(_), do: false

  defp is_authorized_for_user_action?(%User{role: :GENERAL_MANAGER}), do: true
  defp is_authorized_for_user_action?(_, _), do: false
end
