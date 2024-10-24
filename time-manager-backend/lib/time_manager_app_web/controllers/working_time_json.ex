defmodule TimeManagementWeb.WorkingTimeJSON do
  alias TimeManagement.WorkingTimeContext.WorkingTime
  alias TimeManagement.UserContext.User

  @doc """
  Renders a list of workingtime.
  """
  def index(%{workingtime: workingtime}) do
    %{data: for(working_time <- workingtime, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  defp data(%WorkingTime{} = working_time) do
    user_data =
      case working_time.user do
        %User{} = user ->
          %{
            id: user.id,
            firstname: user.firstname,
            lastname: user.lastname,
            email: user.email
          }
        _ -> nil
      end

    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      user: user_data
    }
  end
end
