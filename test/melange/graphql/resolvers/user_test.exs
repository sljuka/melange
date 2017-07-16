defmodule Melange.GraphQL.Resolvers.UserTest do
  alias Melange.Fixture
  use Melange.Web.ConnCase

  describe "Users resource" do
    test "it allows unsigned users to register an account", %{conn: conn} do
      query = """
      mutation {
        create_user(user: {first_name: "Mark", last_name: "Twain", email: "mtwain@fastmail.com", password: "pass1234"}) {
          name
          email
        }
      }
      """

      assert_gql_data conn, query, %{
        "create_user" => %{
          "name" => "Mark Twain",
          "email" => "mtwain@fastmail.com"
        }
      }
    end

    test "it responds with error when registering an account with invalid data", %{conn: conn} do
      query = """
      mutation {
        create_user(user: {first_name: "Mark", not_exist: "Twain"}) {
          name
          email
        }
      }
      """

      assert_gql_error conn, query, ~r/field "not_exist": Unknown field\./, 400
    end

    test "it responds with error when registering an account with incomplete data", %{conn: conn} do
      query = """
      mutation {
        create_user(user: {first_name: "Mark", last_name: "Twain"}) {
          name
          email
        }
      }
      """

      assert_gql_error_map conn, query, [
        %{"email" => %{"details" => %{"validation" => "required"}, "message" => "can't be blank"}},
        %{"password" => %{"details" => %{"validation" => "required"}, "message" => "can't be blank"}}
      ]
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows signed users to update user accounts", %{conn: conn, user: user} do
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
    test "it responds with an error when updating an account with invalid data", %{conn: conn, user: user} do
      query = """
      mutation {
        update_user(id: #{user.id}, user: {first_name: "Bla", not_exist: "ryan@ryan.com"}) {
          id
          name
          email
        }
      }
      """

      assert_gql_error conn, query, ~r/field "not_exist": Unknown field\./, 400
    end

    test "it does not allow unsigned users to update accounts", %{conn: conn} do
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

      assert_gql_not_authenticated_error conn, query
    end

    test "it allows unsigned users to query other users", %{conn: conn} do
      Fixture.user(%{email: "test1@mail.com"})
      Fixture.user(%{email: "test2@mail.com"})
      Fixture.user(%{email: "test3@mail.com"})

      query = """
        {
          users {
            email
          }
        }
      """

      assert_gql_data conn, query, %{
        "users" => [
          %{"email" => "test1@mail.com"},
          %{"email" => "test2@mail.com"},
          %{"email" => "test3@mail.com"}
        ]
      }
    end
  end
end
