defmodule TimeManagementWeb.UserController do
  use TimeManagementWeb, :controller

  alias TimeManagement.{UserContext, Teams}
  alias TimeManagement.UserContext.User

  action_fallback TimeManagementWeb.FallbackController
  plug TimeManagementWeb.Plugs.UsersAuthorizeAccess

  def index(conn, params) do
    email = Map.get(params, "email")
    firstname = Map.get(params, "firstname")
    lastname = Map.get(params, "lastname")
    role = Map.get(params, "role")

    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = Map.get(params, "per_page", "10") |> String.to_integer()

    {users, total_count} = UserContext.get_users_by_search(page, per_page, email, firstname, lastname, role)

    render(conn, :index, users: users, total_count: total_count, page: page, per_page: per_page)
  end

  def list_users_not_in_team(conn, %{"team_id" => team_id}) do
    users = Teams.list_users_not_in_team(team_id)

    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, :show, user: user)
  end

  def show_profile(conn, _params) do
    user = conn.assigns.current_user
    render(conn, :show, user: user)
  end

  def update_profile(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    with {:ok, %User{} = user} <- UserContext.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete_account(conn, _params) do
    user = conn.assigns.current_user

    with {:ok, %User{}} <- UserContext.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def create(conn, %{"user" => user_params}) do
    current_user = conn.assigns.current_user
    with {:ok, %User{} = user} <- UserContext.create_user(current_user, user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)

    with {:ok, %User{}} <- UserContext.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def promote(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)

    with {:ok, %User{} = user} <- UserContext.promote_user(user) do
      render(conn, :show, user: user)
    end
  end
end
