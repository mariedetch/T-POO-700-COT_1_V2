defmodule TimeManagement.Mailer do
  use Swoosh.Mailer, otp_app: :time_manager_app
  import Swoosh.Email

  def send_reset_password_email(email, reset_token) do
    reset_url = "http://localhost:5173/auth/resetpassword?email=#{email}&token=#{reset_token}"

    new()
    |> to(email)
    |> from("no-reply@example.com")
    |> subject("Reset your password")
    |> html_body("Click the link to reset your password: <a href=\"#{reset_url}\">Reset Password</a>")
    |> TimeManagement.Mailer.deliver()
  end
end
