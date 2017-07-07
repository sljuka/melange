defmodule Melange.GraphQL.Resolvers.UsersTest do
  alias Melange.Fixture
  use Melange.Web.ConnCase

  describe "Users" do
    @tag token_login_as: "pera@mail.com"
    test "signed in users can update their account", %{conn: conn, user: user} do
      query = """
        mutation {
          update_user(id: #{user.id}, user: {first_name: "Neil deGrasse", email: "ryan@ryan.com"}) {
            name
            email
          }
        }
      """

      assert_gql_data conn, query, %{
        "update_user" => %{
          "name"  => "Neil deGrasse Tyson",
          "email" => "ryan@ryan.com"
        }
      }
    end

    @tag token_login_as: "pera@mail.com"
    test "in case bad data is sent, server responds with an error", %{conn: conn, user: user} do
      query = """
      mutation {
        update_user(id: #{user.id}, user: {first_name: "Bla", not_existing_field: "ryan@ryan.com"}) {
          id
          name
          email
        }
      }
      """

      assert_gql_error conn, query, ~r/field "not_existing_field": Unknown field\./, 400
    end

    @tag :current
    test "unauthenticated users can't modify accounts", %{conn: conn} do
      user = Fixture.user

      query = """
      mutation {
        update_user(id: #{user.id}, user: {first_name: "Ryan", email: "ryan@ryan.com"}) {
          id
          email
          name
        }
      }
      """

      assert_gql_error conn, query, ~r/not authenticated/
    end

    # @tag token_login_as: "pera@mail.com"
    # test "users can query system users without signing in", %{conn: conn, user: _user} do
    #   Fixture.user(%{email: "test1@mail.com"})
    #   Fixture.user(%{email: "test2@mail.com"})
    #   Fixture.user(%{email: "test3@mail.com"})
    #
    #   query = """
    #     {
    #       users {
    #         email
    #       }
    #     }
    #   """
    #
    #   assert_gql_data conn, query, %{
    #     "users" => [
    #       %{"email" => "pera@mail.com"},
    #       %{"email" => "test1@mail.com"},
    #       %{"email" => "test2@mail.com"},
    #       %{"email" => "test3@mail.com"}
    #     ]
    #   }
    # end
  end
end
