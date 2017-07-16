defmodule Melange.GraphQL.Resolvers.GroupTest do
  alias Melange.Fixture
  use Melange.Web.ConnCase

  describe "Groups resource" do
    @tag token_login_as: "pera@mail.com"
    test "it allows authenticated users to create groups", %{conn: conn, user: _user} do
      query = """
      mutation {
        create_group(group: {name: "Company", description: "Test description"}) {
          name
          description
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "create_group" => %{
            "name" => "Company",
            "description" => "Test description"
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it does not allow groups with same names", %{conn: conn, user: _user} do
      Fixture.group(%{name: "NewName"})

      query = """
      mutation {
        create_group(group: {name: "NewName"}) {
          name
          description
        }
      }
      """

      assert_gql_error_map conn, query, [
        %{"name" => %{"details" => %{}, "message" => "has already been taken"}}
      ]
    end

    @tag token_login_as: "pera@mail.com"
    test "it makes the user who created the group that group's owner", %{conn: conn, user: user} do
      query = """
      mutation {
        create_group(group: {name: "Company", description: "Test description"}) {
          name
          owner {
            email
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{"create_group" => %{
          "name" => "Company",
          "owner" => %{
            "email" => user.email
          }
        }}
    end

    @tag token_login_as: "pera@mail.com"
    test "it makes the user who created the group that group's member", %{conn: conn, user: user} do
      query = """
      mutation {
        create_group(group: {name: "Company"}) {
          name
          members {
            user {
              email
            }
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "create_group" => %{
            "name" => "Company",
            "members" => [
              %{"user" => %{"email" => user.email}}
            ]
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows group owner to update group data", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)

      query = """
      mutation {
        update_group(id: #{group.id}, group: {name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "update_group" => %{
            "name" => "NewName",
            "description" => "New description"
          }
        }
    end

    test "it does not allow unsigned users to update groups", %{conn: conn} do
      group = Fixture.group()

      query = """
      mutation {
        update_group(id: #{group.id}, group: {name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      assert_gql_not_authenticated_error conn, query
    end

    @tag :current
    @tag token_login_as: "pera@mail.com"
    test "signed users can query other groups in the system", %{conn: conn, user: _user} do
      group1 = Fixture.group()
      group2 = Fixture.group()
      group3 = Fixture.group()

      query = """
        {
          groups {
            name
          }
        }
      """

      assert_gql_data conn, query, %{
        "groups" => [
          %{"name" => group1.name},
          %{"name" => group2.name},
          %{"name" => group3.name}
        ]
      }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows users to add new user roles to their groups", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)

      query = """
      mutation {
        add_role(role: {group_id: #{group.id}, name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "add_role" => %{
            "name" => "NewName",
            "description" => "New description"
          }
        }
    end

    @tag :current
    @tag token_login_as: "pera@mail.com"
    test "it does not allow roles with same name to be in the same group", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)
      role = Fixture.role(%{name: "test"}, group, user)

      query = """
      mutation {
        add_role(role: {group_id: #{group.id}, name: "test"}) {
          name
          description
        }
      }
      """

      assert_gql_error_map conn, query, [
        %{"name" => %{"details" => %{}, "message" => "has already been taken"}}
      ]
    end

    @tag :pending
    test "user gets all permissions (super_user role) in group he created" do
    end

    @tag :pending
    test "user can assign roles to other group members with right permission" do
    end

    @tag :pending
    test "user can add new permissions to an existing role" do
    end

    @tag :pending
    test "users can't modify a group if they don't have the right permission" do
    end

    @tag :pending
    test "User can modify a group when another member gives him permission" do
    end
  end
end
