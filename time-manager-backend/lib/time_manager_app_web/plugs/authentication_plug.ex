defmodule TimeManagementWeb.Plugs.AuthenticationPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias TimeManagement.{UserContext, TokenHelper}

  def init(opts), do: opts

  def call(conn, _opts) do
    csrf_token = get_req_header(conn, "c-xsrf-token") |> List.first()
    access_token = conn.req_cookies["access_token"]

    case {csrf_token, access_token} do
      {nil, _} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          status_code: 401,
          message: "Missing CSRF token",
          error: "Unauthorized"
        })
        |> halt()

      {_, nil} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          status_code: 401,
          message: "Missing access token",
          error: "Unauthorized"
        })
        |> halt()

      {csrf_token, access_token} ->
        case TokenHelper.verify_token(access_token) do
          {:ok, claims} ->
            if claims["c-xsrf-token"] == csrf_token do
              user = UserContext.get_user!(claims["sub"])
              conn
              |> assign(:current_user, user)
            else
              conn
              |> put_status(:unauthorized)
              |> json(%{
                status_code: 401,
                message: "CSRF token mismatch",
                error: "Unauthorized"
              })
              |> halt()
            end

          {:error, _reason} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{
              status_code: 401,
              message: "Invalid access token",
              error: "Unauthorized"
            })
            |> halt()
        end
    end
  end
end
