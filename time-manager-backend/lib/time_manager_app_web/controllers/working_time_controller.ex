defmodule TimeManagementWeb.WorkingTimeController do
  use TimeManagementWeb, :controller

  alias TimeManagement.WorkingTimeContext
  alias TimeManagement.WorkingTimeContext.WorkingTime
  alias TimeManagement.UserContext
  alias TimeManagement.Teams

  action_fallback TimeManagementWeb.FallbackController
  plug TimeManagementWeb.Plugs.WorkingtimesAuthorizeAccess

  def list(conn, _params) do
    workingtime = WorkingTimeContext.list_workingtime(conn.assigns.current_user)
    render(conn, :index, workingtime: workingtime)
  end

  def list_by_team(conn, %{"team_id" =>  team_id}) do
    team = Teams.get_team!(team_id)
    workingtime = WorkingTimeContext.list_workingtime_by_team(conn.assigns.current_user, team)
    render(conn, :index, workingtime: workingtime)
  end

  def index(conn, %{"userID" => user_id, "start" => start_date, "end" => end_date}) do
    user = UserContext.get_user!(user_id)

    workingtime = WorkingTimeContext.list_workingtimes_by_id(user.id, start_date, end_date)
    render(conn, :index, workingtime: workingtime)
  end

  def index(conn, %{"userID" => user_id}) do
    user = UserContext.get_user!(user_id)

    workingtime = WorkingTimeContext.list_workingtimes(user.id)
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, %{"team_id" => team_id, "userID" => user_id, "workingtime" =>  workingtime_params}) do
    user = UserContext.get_user!(user_id)
    team = Teams.get_team!(team_id)
    current_user = conn.assigns.current_user
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimeContext.create_working_time(current_user, team, user, workingtime_params) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  def create_for_users(conn, %{"team_id" => team_id, "userIDs" => user_ids, "workingtime" => workingtime_params}) do
    users = Enum.map(user_ids, fn user_id -> UserContext.get_user!(user_id) end)
    team = Teams.get_team!(team_id)
    current_user = conn.assigns.current_user
    working_time_results = WorkingTimeContext.create_working_times_for_users(current_user, team, users, workingtime_params)
    errors = Enum.filter(working_time_results, fn
      {:error, _changeset} -> true
      _ -> false
    end)
    if errors == [] do
      conn
      |> put_status(:created)
      |> json(%{message: "Working times created successfully for all users."})
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{errors: "Some working times could not be created."})
    end
  end

  def show(conn, %{"userID" => user_id, "id" => id}) do
    user = UserContext.get_user!(user_id)
    working_time = WorkingTimeContext.get_working_time!(id, user.id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "workingtime" => working_time_params}) do
    working_time = WorkingTimeContext.get_working_time_2!(id) # j'utilise la nouvelle fonction get_working_time_2

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimeContext.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimeContext.get_working_time_2!(id) # j'utilise la nouvelle fonction get_working_time_2

    with {:ok, %WorkingTime{}} <- WorkingTimeContext.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
