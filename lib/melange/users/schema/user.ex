defmodule Melange.Users.User do
  alias Melange.Users.User
  import Ecto.Changeset
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :owned_groups, Melange.Groups.Group, foreign_key: :owner_id
    has_many :members, Melange.Groups.Member
    has_many :group_invites, Melange.Groups.GroupInvite

    timestamps()
  end

  def changeset(%User{} = user, params) do
    user
    |> cast(params, [:first_name, :last_name, :email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, message: "has_been_taken")
    |> hash_password()
  end

  def update_changeset(%User{} = user, params) do
    user
    |> cast(params, [:first_name, :last_name, :email, :password])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email, message: "has_been_taken")
    |> hash_password()
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
