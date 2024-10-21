defmodule TimeManagementWeb.MemberController do
  use TimeManagementWeb, :controller

  alias TimeManagement.Members
  alias TimeManagement.Members.Member

  action_fallback TimeManagementWeb.FallbackController

  def index(conn, %{"team_id" => team_id} = params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = Map.get(params, "per_page", "10") |> String.to_integer()

    {members, total_count} = Members.list_members(team_id, page, per_page)
    render(conn, :index, members: members, total_count: total_count, page: page, per_page: per_page)
  end

  def create(conn, %{"team_id" => team_id, "user_ids" => user_ids}) do
    auth_id = conn.assigns.current_user.id
    case Members.add_members_to_team(team_id, user_ids, auth_id) do
      {:ok, _successful_inserts} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "Members added successfully",
          team_id: team_id,
          added_members: user_ids
        })

      {:error, "All members already exist in the team"} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "All members already exist in the team"})

      {:error, failed_inserts} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Failed to add one or more members",
          failed_inserts: Enum.map(failed_inserts, fn {:error, changeset} -> changeset end)
        })
    end
  end

  def show(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    render(conn, :show, member: member)
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = Members.get_member!(id)

    with {:ok, %Member{} = member} <- Members.update_member(member, member_params) do
      render(conn, :show, member: member)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Members.get_member!(id)

    with {:ok, %Member{}} <- Members.soft_delete_member(member) do
      send_resp(conn, :no_content, "")
    end
  end
end
