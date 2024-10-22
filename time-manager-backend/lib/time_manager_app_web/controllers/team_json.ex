defmodule TimeManagementWeb.TeamJSON do
  alias TimeManagement.Teams.Team

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

  defp data(%{team: %Team{} = team, member_count: member_count}) do
    team_json = data(team)
    Map.put(team_json, :member_count, member_count)
  end

  defp data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      description: team.description,
      inserted_at: team.inserted_at,
      updated_at: team.updated_at,
      manager: if Ecto.assoc_loaded?(team.manager) do
        %{
          id: team.manager.id,
          firstname: team.manager.firstname,
          lastname: team.manager.lastname,
          email: team.manager.email
        }
      else
        nil
      end
    }
  end
end
