defmodule TimeManagementWeb.ClockController do
  use TimeManagementWeb, :controller

  alias TimeManagement.ClockContext
  alias TimeManagement.ClockContext.Clock
  alias TimeManagement.UserContext

  action_fallback TimeManagementWeb.FallbackController

  def index(conn, %{"userId" => userId}) do
    user = UserContext.get_user!(userId)
    clocks = ClockContext.list_clocks_by_user(user)
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"userId" => userId}) do
    user = UserContext.get_user!(userId)
    with {:ok, %Clock{} = clock} <- ClockContext.clock_in_or_out(user) do
      conn
      |> put_status(:created)
      |> render(:show, clock: clock)
    end
  end
end
