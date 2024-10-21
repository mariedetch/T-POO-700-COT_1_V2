defmodule TimeManagementWeb.MemberJSON do
  alias TimeManagement.Members.Member
  alias TimeManagement.UserContext.User

  @doc """
  Renders a list of members.
  """
  def index(%{members: members}) do
    %{data: for(member <- members, do: data(member))}
  end

  def index(%{members: members, total_count: total_count, page: page, per_page: per_page}) do
    %{
      data: %{
        items: for(member <- members, do: data(member)),
        total_count: total_count,
        page: page,
        per_page: per_page
      }
    }
  end


  @doc """
  Renders a single member.
  """
  def show(%{member: member}) do
    %{data: data(member)}
  end

  defp data(%Member{} = member) do
    case member.user do
      %User{} = userT ->
        %{
          id: member.id,
          user: %{
            id: userT.id,
            firstname: userT.firstname,
            lastname: userT.lastname,
            email: userT.email
          }
        }
      _ ->
        %{
          id: member.id,
          user_id: member.user_id
        }
    end
  end
end
