defmodule Melange.Groups.Member do
  alias Melange.Groups.Group
  alias Melange.Users.User
  alias Melange.Groups.MemberRole
  import Ecto.Changeset
  use Ecto.Schema

  schema "members" do
    belongs_to :user, User
    belongs_to :group, Group
    has_many   :member_roles, MemberRole
    has_many   :roles, through: [:member_roles, :role]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_id, :user_id])
    |> validate_required([:group_id, :user_id])
  end
end
