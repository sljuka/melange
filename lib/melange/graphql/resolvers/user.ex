defmodule Melange.GraphQL.Resolvers.User do
  alias Melange.Users

  def list_users(_args, _info) do
    {:ok, Users.list_users}
  end

  def update_user(_args, _info) do
    {:ok, Enum.at(Users.list_users, 0)}
  end
end
