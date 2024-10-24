defmodule TimeManagement.UserContextTest do
  use TimeManagement.DataCase

  alias TimeManagement.UserContext

  describe "users" do
    alias TimeManagement.UserContext.User

    import TimeManagement.UserContextFixtures

    @invalid_attrs %{username: nil, email: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end
  end
end
