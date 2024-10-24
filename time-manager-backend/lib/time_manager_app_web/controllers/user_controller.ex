defmodule TimeManagementWeb.UserController do
  use TimeManagementWeb, :controller

  import Ecto.Query, warn: false
  alias TimeManagement.Repo
  alias TimeManagement.{UserContext, Teams, TokenHelper, Mailer}
  alias TimeManagement.UserContext.User
  alias TimeManagement.WorkingTimeContext.WorkingTime
  alias TimeManagement.ClockContext.Clock

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
      csrf_token = TokenHelper.generate_csrf_token()
      {:ok, token, _claims} = TokenHelper.generate_token(user, csrf_token)

      Mailer.send_activation_email(user.email, token)
      IO.inspect(token)
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

  def promote(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id)

    with {:ok, %User{} = user} <- UserContext.promote_user(user) do
      render(conn, :show, user: user)
    end
  end

  def stats_for_user(conn, _params) do
    # Obtenez toutes les heures de travail
    working_times = Repo.all(WorkingTime)
    # Obtenez tous les horodatages
    clocks = Repo.all(Clock)

    # Regroupez les heures de travail par jour
    working_hours =
      working_times
      |> Enum.group_by(&Date.to_string(&1.start |> DateTime.to_date()))

    # Regroupez les horodatages par jour et par statut
    clocked_hours =
      clocks
      |> Enum.group_by(&Date.to_string(&1.time |> DateTime.to_date()))
      |> Enum.map(fn {date, entries} ->
        total_hours = Enum.count(entries) / 2 # Chaque entrée doit avoir un statut d'arrivée et de départ
        {date, total_hours}
      end)
      |> Enum.into(%{})

    # Créez la réponse finale
    response = Enum.map(working_hours, fn {date, working_entries} ->
      planned_hours = Enum.reduce(working_entries, 0, fn entry, acc ->
        DateTime.diff(entry.end, entry.start) + acc
      end)

      actual_hours = Map.get(clocked_hours, date, 0)
      %{date: date, planned_hours: planned_hours, actual_hours: actual_hours}
    end)

    json(conn, response)
  end
end
