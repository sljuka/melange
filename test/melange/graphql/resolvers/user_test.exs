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

    test "it allows user to login and retrieve a jwt, which user can append to request as header for authentication purposes", %{conn: conn} do
      user = Fixture.user(%{email: "user@mail.com"})

      query = """
      mutation {
        login(email: "#{user.email}", password: "test1234") {
          token
        }
      }
      """

      token_data = gql_data conn, query

      assert(byte_size(token_data["login"]["token"]) > 50)
    end

    @tag :current
    test "it reports an error in case user tries to login with bad creds", %{conn: conn} do
      query = """
      mutation {
        login(email: "nonExisting@mail.com", password: "test1234") {
          token
        }
      }
      """

      assert_gql_error_data conn, query, [%{
        "field" => "email",
        "message" => "Invalid email or password",
        "short_message" => "invalid_creds"
      }]
    end

    @tag :current
    test "it responds with error when registering an account with invalid data", %{conn: conn} do
      query = """
      mutation {
        create_user(user: {first_name: "Mark", not_exist: "Twain"}) {
          name
          email
        }
      }
      """

      assert_gql_error_data conn, query, [
        %{
          "message" => "Argument \"user\" has invalid value {first_name: \"Mark\", not_exist: \"Twain\"}.\nIn field \"not_exist\": Unknown field.",
          "locations" => [%{"column" => 0, "line" => 2}]
        }
      ], 400
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

      assert_gql_error_data conn, query, [
        %{"field" => "email", "message" => "Value can't be blank", "short_message" => "can_not_be_blank"},
        %{"field" => "password", "message" => "Value can't be blank", "short_message" => "can_not_be_blank"}
      ]
    end

    @tag :token_login
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

    @tag :current
    @tag :token_login
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

      assert_gql_error_data conn, query, [%{
        "message" => "Argument \"user\" has invalid value {first_name: \"Bla\", not_exist: \"ryan@ryan.com\"}.\nIn field \"not_exist\": Unknown field.",
        "locations" => [%{"column" => 0, "line" => 2}]
      }], 400
    end

    @tag :current
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

      assert_gql_error_data conn, query, [%{
        "message" => "User is not authenticated", "field" => "", "short_message" => "not_authenticated"
      }]
    end

    @tag :current
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
