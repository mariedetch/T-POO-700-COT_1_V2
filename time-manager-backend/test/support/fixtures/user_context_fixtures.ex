defmodule TimeManagement.UserContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagement.UserContext` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user username.
  """
  def unique_user_firstname, do: "some firstname#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user username.
  """
  def unique_user_lastname, do: "some lastname#{System.unique_integer([:positive])}"


  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    user_attrs =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        lastname: unique_user_lastname(),
        firstname: unique_user_firstname(),
        role: "GENERAL_MANAGER"
      })
      
    {:ok, user} =
      user_attrs
      |> TimeManagement.UserContext.create_user()
    
    user
  end
end
