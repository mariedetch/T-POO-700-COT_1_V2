defmodule TimeManagementWeb.ErrorJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """

  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes

  def render("404.json", _assigns) do
    %{
      status_code: 404,
      message: "Ressource non trouvée",
      error: "Not Found"
    }
  end

  def render("400.json", _assigns) do
    %{
      status_code: 400,
      message: "Requête invalide",
      error: "Bad Request"
    }
  end

  def render("500.json", _assigns) do
    %{
      status_code: 500,
      message: "Erreur interne du serveur",
      error: "Internal Server Error"
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      status_code: 422,
      message: "Validation failed",
      errors: translate_errors(changeset)
    }
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
