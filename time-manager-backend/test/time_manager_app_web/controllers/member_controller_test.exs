defmodule TimeManagementWeb.MemberControllerTest do
  use TimeManagementWeb.ConnCase

  import TimeManagement.MembersFixtures

  alias TimeManagement.Members.Member

  @create_attrs %{
    team_id: "some team_id",
    user_id: "some user_id"
  }
  @update_attrs %{
    team_id: "some updated team_id",
    user_id: "some updated user_id"
  }
  @invalid_attrs %{team_id: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all members", %{conn: conn} do
      conn = get(conn, ~p"/api/members")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create member" do
    test "renders member when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/members", member: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/members/#{id}")

      assert %{
               "id" => ^id,
               "team_id" => "some team_id",
               "user_id" => "some user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/members", member: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update member" do
    setup [:create_member]

    test "renders member when data is valid", %{conn: conn, member: %Member{id: id} = member} do
      conn = put(conn, ~p"/api/members/#{member}", member: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/members/#{id}")

      assert %{
               "id" => ^id,
               "team_id" => "some updated team_id",
               "user_id" => "some updated user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, member: member} do
      conn = put(conn, ~p"/api/members/#{member}", member: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete member" do
    setup [:create_member]

    test "deletes chosen member", %{conn: conn, member: member} do
      conn = delete(conn, ~p"/api/members/#{member}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/members/#{member}")
      end
    end
  end

  defp create_member(_) do
    member = member_fixture()
    %{member: member}
  end
end
