defmodule TimeManagementWeb.ClockJSON do
  alias TimeManagement.ClockContext.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: grouped_clocks}) do
    %{data: for {day, clocks_on_day} <- grouped_clocks do
      %{
        day: day,
        clocks: for(clock <- clocks_on_day, do: data(clock))
      }
    end}
  end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  defp data(%Clock{} = clock) do
    %{
      id: clock.id,
      time: clock.time,
      status: clock.status
    }
  end
end
