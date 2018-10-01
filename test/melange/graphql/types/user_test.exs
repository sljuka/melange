defmodule Melange.GraphQL.TypesTest do
  alias Melange.Fixture
  use Melange.Web.ConnCase

  describe "User type" do
    @tag :current
    @tag :token_login
    test "Users can query users", %{conn: conn, user: user} do
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
      
      %{ data: data } = Absinthe.run!(query, Melange.GraphQL.Schema)
      assert data == %{
        "users" => [
          %{
            "email" => "test@mail.com",
            "first_name" => "Mike",
            "group_invites" => [],
            "id" => "#{user.id}",
            "last_name" => "Tyson",
            "name" => "Mike Tyson",
            "owned_groups" => []
          }
        ]
      }
    end
  end
end
