defmodule Melange.GraphQL.Resolvers.User do
  alias Melange.Adapters.GraphQLContextAdapter, as: ContextAdapter
  alias Melange.Adapters.ArgsStringifierAdapter, as: ArgsAdapter
  alias Melange.ErrorAdapter
  alias Melange.Users

  def list_users(_args, _info) do
    {:ok, Users.list_users()}
  end

  def update_user(args, info) do
    context = ContextAdapter.adapt(info)
    adapted_args = ArgsAdapter.adapt(args)

    %{"id" => id, "user" => user_args} = adapted_args
    merged_args = Map.merge(%{"id" => id}, user_args)

    Users.update_user(merged_args, context)
    |> ErrorAdapter.adapt
  end

  def create_user(args, _info) do
    adapted_args = ArgsAdapter.adapt(args)
    %{"user" => user_args} = adapted_args

    Users.create_user(user_args, %{})
    |> ErrorAdapter.adapt
  end

  def search(args, info) do
    %{email: email} = args

    Users.search(email, info)
    |> ErrorAdapter.adapt
  end

  def login(%{email: email, password: password}, _info) do
    with {:ok, user} <- Users.find_and_checkpw(email, password),
         {:ok, jwt, _ } <- Guardian.encode_and_sign(user, :access)
    do
      {:ok, %{token: jwt}}
    else
      _err -> {:error, "email", :invalid_creds}
    end
    |> ErrorAdapter.adapt
  end
end
