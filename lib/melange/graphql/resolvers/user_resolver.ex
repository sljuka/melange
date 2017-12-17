defmodule Melange.GraphQL.UserResolver do
  @moduledoc """
  Graphql integration layer for user features
  """

  alias Melange.Adapters.GraphQLContextAdapter, as: ContextAdapter
  alias Melange.Adapters.ArgsStringifierAdapter, as: ArgsAdapter
  alias Melange.Adapters.GraphQLErrorAdapter, as: ErrorAdapter
  alias Melange.Users

  def list_users(_args, _info) do
    {:ok, Users.list_users()}
  end

  def update_user(args, info) do
    context = ContextAdapter.adapt(info)
    adapted_args = ArgsAdapter.adapt(args)

    %{"id" => id, "user" => user_args} = adapted_args
    merged_args = Map.merge(%{"id" => id}, user_args)

    merged_args
    |> Users.update_user(context)
    |> ErrorAdapter.adapt
  end

  def create_user(args, _info) do
    adapted_args = ArgsAdapter.adapt(args)
    %{"user" => user_args} = adapted_args

    user_args
    |> Users.create_user(%{})
    |> ErrorAdapter.adapt
  end

  def search(args, info) do
    %{email: email} = args

    email
    |> Users.search(info)
    |> ErrorAdapter.adapt
  end

  def current_user(args, %{context: context}) do
    args
    |> Users.current_user(context)
    |> ErrorAdapter.adapt
  end

  def login(%{email: email, password: password}, _info) do
    with {:ok, user} <- Users.find_and_checkpw(email, password),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user, :access)
    do
      {:ok, %{token: jwt}}
    else
      _err -> {:error, "email", :invalid_creds}
    end
    |> ErrorAdapter.adapt
  end
end
