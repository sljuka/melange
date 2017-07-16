defmodule Melange.GraphQL.Resolvers.User do
  alias Melange.Users
  alias Melange.GraphQL.Adapters.ErrorAdapter

  def list_users(_args, _info) do
    {:ok, Users.list_users()}
  end

  def update_user(args, %{context: context}) do
    %{id: id, user: user_args} = args

    Users.update_user(id, user_args, context)
  end

  def create_user(args, _info) do
    %{user: user_args} = args

    res = Users.create_user(user_args)
    ErrorAdapter.adapt(res)
  end
end
