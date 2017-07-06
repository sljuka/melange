defmodule Melange.Users do
  alias Melange.Users
  alias Melange.Users.User
  alias Melange.Repo
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def list_users, do: Repo.all(User)

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(args), do: create_user({:ok, "ok"}, args)
  def create_user({:error, _reason} = res, _args), do: res
  def create_user(_prev, args) do
    %User{}
      |> user_changeset(args)
      |> Repo.insert
  end

  def update_user(args), do: update_user({:ok, "ok"}, args)
  def update_user({:error, _reason} = res, _args), do: res
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  def create_token(user, password) do
    with {:ok, user} <- find_and_checkpw(user, password),
         {:ok, jwt, _ } <- Guardian.encode_and_sign(user, :access) do
      {:ok, jwt}
    end
  end

  def delete_user(%User{} = user), do: Repo.delete(user)

  def find_user(email), do: Repo.get_by(User, email: email)

  def find_and_checkpw(email, password) do
    user = Users.find_user(email)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        # simulate check password hash timing
        dummy_checkpw()
        {:error, :not_found}
    end
  end

  def user_changeset(%User{} = user, params), do: User.changeset(user, params)
end
