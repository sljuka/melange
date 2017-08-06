defmodule Melange.Users do
  alias Melange.Users
  alias Melange.Users.User
  alias Melange.Repo
  alias Melange.Bouncer
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  require IEx;

  def list_users, do: Repo.all(User)

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def search(email, _context), do: {:ok, Repo.get_by(User, email: email)}

  def create_user(args) do
    %User{}
    |> User.changeset(args)
    |> Repo.insert
  end

  def update_user(id, args, context) do
    with :ok <- Bouncer.check_authentication(context)
    do
      user = Users.get_user!(id)

      user
      |> update_user_changeset(args)
      |> Repo.update
    end
  end

  def create_token(user, password) do
    with {:ok, user} <- find_and_checkpw(user, password),
         {:ok, jwt, _ } <- Guardian.encode_and_sign(user, :access) do
      {:ok, jwt}
    end
  end

  def delete_user(id, context) do
    with :ok <- Bouncer.check_authentication(context)
    do
      user = Users.get_user(id)
      current = context.current_user

      case user do
        nil -> {:error, :not_found}
        ^current -> {:error, :self_delete}
        _ -> Repo.delete(user)
      end
    end
  end

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

  def update_user_changeset(%User{} = user, params), do: User.update_changeset(user, params)
  def user_changeset(%User{} = user, params), do: User.changeset(user, params)
end
