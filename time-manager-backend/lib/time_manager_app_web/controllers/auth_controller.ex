defmodule TimeManagementWeb.AuthController do
  use TimeManagementWeb, :controller

  alias TimeManagement.{UserContext, TokenHelper, Mailer}

  action_fallback TimeManagementWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    case UserContext.authenticate_user(email, Base.decode64!(password)) do
      {:ok, user} ->
        csrf_token = TokenHelper.generate_csrf_token()
        {:ok, token, _claims} = TokenHelper.generate_token(user, csrf_token)

        # Set the JWT in an HTTP-only cookie
        conn
        |> put_resp_cookie("access_token", token, http_only: true, secure: true, max_age: 3600)
        |> json(%{
          status_code: 200,
          status: "OK",
          data: %{
            csrf_token: csrf_token,
            user: %{
              id: user.id,
              firstname: user.firstname,
              lastname: user.lastname,
              email: user.email,
              role: user.role
            }
          }})

      {:error, :user_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{status_code: 404, status: "Not Found", message: "User not found"})

      {:error, :invalid_password} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{status_code: 422, status: "Unprocessable Entity", message: "Invalid credentials"})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{status_code: 500, status: "Internal Server Error", message: "Internal error"})
    end
  end

  def forgot_password(conn, %{"email" => email}) do
    user = UserContext.find_by_email!(email)
    {:ok, token, _claims} = TokenHelper.generate_reset_token(user.id, user.email)

    Mailer.send_reset_password_email(user.email, token)

    conn
    |> put_status(:ok)
    |> json(%{
      status_code: 200,
      status: "OK",
      message: "Reset password instructions sent to your email"
    })
  end

  def verify_token(conn, %{"token" => token, "email" => email}) do
    case TokenHelper.verify_token(token) do
      {:ok, claims} ->
        if claims["email"] == email do
          conn
          |> put_status(:ok)
          |> json(%{
            status_code: 200,
            message: "Token verified successfully",
            status: "Ok"
          })
          |> halt()
        else
          conn
          |> put_status(:bad_request)
          |> json(%{
            status_code: 400,
            message: "Verification token mismatch",
            error: "Bad Request"
          })
          |> halt()
        end

      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status_code: 400,
          message: "Invalid or expired token",
          error: "Bad Request"
        })
        |> halt()
    end
  end

  def reset_password(conn, %{"token" => token, "password" => password}) do
    case TokenHelper.verify_token(token) do
      {:ok, claims} ->
        user_id = claims["sub"]
        case UserContext.reset_password(user_id, Base.decode64!(password)) do
          {:ok, _user} ->
            conn
            |> put_status(:ok)
            |> json(%{
              status_code: 200,
              message: "Password reset successfully",
              timestamp: DateTime.utc_now()
            })

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              status_code: 422,
              message: "Unable to reset password",
              timestamp: DateTime.utc_now()
            })
        end

      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status_code: 404,
          message: "Invalid or expired token",
          timestamp: DateTime.utc_now()
        })
    end
  end

  def activate_account(conn, %{"token" => token, "user" => user_params}) do
    case TokenHelper.verify_token(token) do
      {:ok, claims} ->
        user_id = claims["sub"]
        user = UserContext.get_user!(user_id)

        with {:ok, user} <- UserContext.update_user(user, user_params) do
          conn
          |> put_status(:ok)
          |> json(%{
            status_code: 200,
            status: "OK",
            message: "Account activated successfully"
          })
        end
      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status_code: 404,
          message: "Invalid or expired token",
          timestamp: DateTime.utc_now()
        })
    end
  end
end
