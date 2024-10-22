defmodule TimeManagementWeb.ErrorJSONTest do
  use TimeManagementWeb.ConnCase, async: true

  test "renders 404" do
    assert TimeManagementWeb.ErrorJSON.render("404.json", %{}) ==
      %{
        status_code: 404,
        message: "Ressource non trouvée",
        error: "Not Found"
      }
  end

  test "renders 500" do
    assert TimeManagementWeb.ErrorJSON.render("500.json", %{}) ==
      %{
        status_code: 500,
        message: "Erreur interne du serveur",
        error: "Internal Server Error"
      }
  end
end
