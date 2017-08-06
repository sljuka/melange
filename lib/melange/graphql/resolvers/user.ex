defmodule Melange.GraphQL.Resolvers.User do
  alias Melange.Users
  alias Melange.ErrorAdapter

  def list_users(_args, _info) do
    {:ok, Users.list_users()}
  end

  def update_user(args, %{context: context}) do
    %{id: id, user: user_args} = args

    Users.update_user(id, user_args, context)
  end

  def create_user(args, _info) do
    %{user: user_args} = args

    Users.create_user(user_args)
    |> ErrorAdapter.adapt
  end

  def search(args, info) do
    %{email: email} = args

    Users.search(email, info)
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
