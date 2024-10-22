defmodule TimeManagement.TokenHelper do
  use Joken.Config

  @secret_key "SOME_SECRET_KEY"
  @token_ttl 60 * 60 * 24

  @impl true
  def token_config do
    %{
      default_claims: %{
        exp: current_time() + @token_ttl
      }
    }
  end

  # Generate a random CSRF token
  def generate_csrf_token do
    :crypto.strong_rand_bytes(25) |> Base.url_encode64(padding: false) |> String.slice(0..49)
  end

  def signer do
    Joken.Signer.create("HS256", @secret_key)
  end

  # Generate a signed token for a user
  def generate_token(user, csrf_token) do
    claims = %{
      "c-xsrf-token" => csrf_token,
      "sub" => to_string(user.id),
      "role" => user.role,
      "exp" => current_time() + @token_ttl
    }

    Joken.encode_and_sign(claims, signer())
  end

  def generate_reset_token(user_id, email) do
    claims = %{
      "sub" => to_string(user_id),
      "email" => email,
      "exp" => current_time() + 3600 # 1h
    }

    Joken.encode_and_sign(claims, signer())
  end

  # Verify the token
  def verify_token(token) do
    TimeManagement.TokenHelper.verify_and_validate(token, signer())
  end
end
