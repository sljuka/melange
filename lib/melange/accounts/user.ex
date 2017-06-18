defmodule Melange.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melange.Accounts.User


  schema "accounts_users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
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
    |> unique_constraint(:email)
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
