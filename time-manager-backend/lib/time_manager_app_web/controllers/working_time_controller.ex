defmodule TimeManagementWeb.WorkingTimeController do
  use TimeManagementWeb, :controller

  alias TimeManagement.WorkingTimeContext
  alias TimeManagement.WorkingTimeContext.WorkingTime
  alias TimeManagement.UserContext

  action_fallback TimeManagementWeb.FallbackController

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

  def create(conn, %{"userID" => user_id, "workingtime" =>  workingtime_params}) do
    user = UserContext.get_user!(user_id)
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimeContext.create_working_time(user, workingtime_params) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
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
