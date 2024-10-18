defmodule TimeManagementWeb.Plugs.AuthenticationPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias TimeManagement.TokenHelper

  def init(opts), do: opts

  def call(conn, _opts) do
    csrf_token = get_req_header(conn, "x-xsrf-token") |> List.first()
    access_token = get_req_header(conn, "authorization") |> List.first()

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

      {csrf_token, "Bearer " <> access_token} ->
        case TokenHelper.verify_token(access_token) do
          {:ok, claims} ->
            # Vérification du CSRF token dans le JWT
            if claims["c-xsrf-token"] == csrf_token do
              conn  # Si les tokens sont valides, continuer la requête
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

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          status_code: 401,
          message: "Unauthorized access",
          error: "Unauthorized"
        })
        |> halt()
    end
  end
end
