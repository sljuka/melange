defmodule Melange.GraphQL.Resolvers.User do
  alias Melange.Users

  def list_users(_args, _info) do
    {:ok, Users.list_users}
  end

  def update_user(args, %{context: context}) do
    %{id: id, user: user_args} = args

    Users.update_user(id, user_args, context)
  end

  def create_user(args, _info) do
    Users.create_user(args)
  end
end
