defmodule TimeManagementWeb.UserJSON do
  alias TimeManagement.UserContext.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      matricule: user.matricule,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      role: user.role
    }
  end
end
