defmodule TimeManagement.MembersTest do
  use TimeManagement.DataCase

  alias TimeManagement.Members

  describe "members" do
    alias TimeManagement.Members.Member

    import TimeManagement.MembersFixtures

    @invalid_attrs %{team_id: nil, user_id: nil}

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Members.list_members() == [member]
    end
  end
end
