defmodule Melange.Groups.Group do
  alias Melange.Groups.Group
  import Ecto.Changeset
  use Ecto.Schema

  schema "groups" do
    field      :name,          :string
    field      :description,   :string
    belongs_to :owner,         Melange.Users.User, foreign_key: :owner_id
    has_many   :members,       Melange.Groups.Member
    has_many   :roles,         Melange.Groups.Role
    has_many   :join_requests, Melange.Groups.JoinRequest

    timestamps()
  end

  def changeset(%Group{} = group, params \\ %{}) do
    group
    |> cast(params, [:name, :owner_id, :description])
    |> validate_required([:name, :owner_id])
    |> unique_constraint(:name, message: "has_been_taken")
  end
end
