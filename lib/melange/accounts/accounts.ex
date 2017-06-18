defmodule Melange.Accounts do
  alias Melange.Accounts
  alias Melange.Accounts.User
  alias Melange.Repo
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.{Query, Changeset}, warn: false

  def list_users(), do: list_users({:ok, "ok"})
  def list_users({:error, _reason} = res), do: res
  def list_users(_prev) do
    {:ok, Repo.all(User)}
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(args), do: create_user({:ok, "ok"}, args)
  def create_user({:error, _reason} = res, _args), do: res
  def create_user(_prev, args) do
    %User{}
      |> registration_changeset(args)
      |> Repo.insert
  end

  def update_user(%User{} = user, attrs) do
    user
    |> update_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def find_user(email) do
    Repo.get_by(User, email: email)
  end

  def registration_changeset(%User{} = user, params) do
    user
    |> cast(params, [:first_name, :last_name, :email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> hash_password()
  end

  def update_changeset(%User{} = user, params) do
    user
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
  end

  def find_and_checkpw(email, password) do
    user = Accounts.find_user(email)

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

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
