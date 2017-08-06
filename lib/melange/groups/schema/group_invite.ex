defmodule Melange.Groups.GroupInvite do
  import Ecto.Changeset
  use Ecto.Schema

  schema "group_invites" do
    belongs_to :user, Melange.Users.User
    belongs_to :group, Melange.Groups.Group

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_id, :user_id])
    |> validate_required([:group_id, :user_id])
    |> unique_constraint(:user_id, name: :group_invites_user_id_group_id_index, message: "user_already_invited")
  end
end
