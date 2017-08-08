defmodule Melange.GraphQL.TypesTest do
  alias Melange.Fixture
  use Melange.Web.ConnCase

  describe "User type" do
    @tag :current
    @tag :token_login
    test "it allows users to fetch groups by name", %{conn: conn, user: user} do
      query = """
      {
        users {
          id
          email
          first_name
          last_name
          owned_groups { id }
          group_invites { id }
          name
        }
      }
      """

      assert_gql_data conn, query, %{
        "users" => [%{
          "id" => "#{user.id}",
          "email" => user.email,
          "name" => "#{user.first_name} #{user.last_name}",
          "first_name" => user.first_name,
          "last_name" => user.last_name,
          "owned_groups" => [],
          "group_invites" => []
        }]
      }
    end
  end
end
