defmodule TimeManagementWeb.ClockController do
  use TimeManagementWeb, :controller

  alias TimeManagement.ClockContext
  alias TimeManagement.ClockContext.Clock

  action_fallback TimeManagementWeb.FallbackController

  def index(conn, _params) do
    clocks = ClockContext.list_clocks_grouped_by_day(conn.assigns.current_user.id)
    render(conn, :index, clocks: clocks)
  end

  def list_clocks_by_user(conn, %{"user_id" => user_id}) do
    clocks = ClockContext.list_clocks_grouped_by_day(user_id)
    render(conn, :index, clocks: clocks)
  end

  def show(conn, _params) do
    case ClockContext.get_latest_clock_by_user(conn.assigns.current_user.id) do
      {:ok, clock} ->
        render(conn, :show, clock: clock)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Clock not found for the given user"})
    end
  end

  def create(conn, _params) do
    user = conn.assigns.current_user
    with {:ok, %Clock{} = clock} <- ClockContext.clock_in_or_out(user) do
      conn
      |> put_status(:created)
      |> render(:show, clock: clock)
    end
  end
end
