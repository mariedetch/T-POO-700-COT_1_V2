defmodule TimeManagementWeb.UserController do
  use TimeManagementWeb, :controller

  alias TimeManagement.UserContext
  alias TimeManagement.UserContext.User

  action_fallback TimeManagementWeb.FallbackController

  def index(conn, params) do
    email = Map.get(params, "email")
    firstname = Map.get(params, "firstname")
    lastname = Map.get(params, "lastname")
    matricule = Map.get(params, "matricule")
    role = Map.get(params, "role")

    users = UserContext.get_users_by_search(email, firstname, lastname, matricule, role)
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, :show, user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserContext.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    with {:ok, %User{} = user} <- UserContext.update_user(user, user_params) do
      render(conn, :show, user: user)
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
