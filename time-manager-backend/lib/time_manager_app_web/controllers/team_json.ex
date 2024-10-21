defmodule TimeManagementWeb.TeamJSON do
  alias TimeManagement.Teams.Team
  alias TimeManagement.UserContext.User

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams, total_count: total_count, page: page, per_page: per_page}) do
    %{
      data: %{
        items: for(team <- teams, do: data(team)),
        total_count: total_count,
        page: page,
        per_page: per_page
      }
    }
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: data(team)}
  end

  defp data(%Team{} = team) do
    manager_data =
      case team.manager do
        %User{} = manager ->
          %{
            id: manager.id,
            firstname: manager.firstname,
            lastname: manager.lastname,
            email: manager.email
          }
        _ -> nil
      end

    created_by_data =
      case team.created_by do
        %User{} = created_by ->
          %{
            id: created_by.id,
            firstname: created_by.firstname,
            lastname: created_by.lastname,
            email: created_by.email
          }
        _ -> nil
      end

    %{
      id: team.id,
      name: team.name,
      description: team.description,
      inserted_at: team.inserted_at,
      manager: manager_data,
      created_by: created_by_data,
    }
  end
end
