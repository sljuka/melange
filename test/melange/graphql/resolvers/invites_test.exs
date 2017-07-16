defmodule Melange.GraphQL.Resolvers.InviteTest do
  alias Melange.Fixture
  use Melange.Web.ConnCase

  describe "Invites" do
    @tag :pending
    test "users can request to join a group", %{conn: conn, user: user} do
    end

    @tag :pending
    test "in case user is not authenticated, he can't accept group join requests", %{conn: conn, user: user} do
    end

    @tag :pending
    test "users can accept new members into their groups with right permission", %{conn: conn, user: user} do
    end

    @tag :pending
    test "user can't request to join group if he is already a member of that group", %{conn: conn, user: user} do
    end

    @tag :pending
    test "users can invite other users to join their group", %{conn: conn, user: user} do
    end

    @tag :pending
    test "users can accept group invitations", %{conn: conn, user: user} do
    end

    @tag :pending
    test "users can accept only their invitations", %{conn: conn, user: user} do
    end
  end
end
