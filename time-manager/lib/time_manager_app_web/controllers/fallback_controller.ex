defmodule TimeManagementWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TimeManagementWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(TimeManagementWeb.ErrorJSON)
    |> render("404.json")
  end

  # for bad request
  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(TimeManagementWeb.ErrorJSON)
    |> render("400.json")
  end

  # Gestion des erreurs de validation (400 Bad Request)
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)  # 422 Unprocessable Entity
    |> put_view(TimeManagementWeb.ErrorJSON)
    |> render("error.json", changeset: changeset)
  end
end
