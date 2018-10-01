defmodule Melange.Groups.JoinRequest do
  import Ecto.Changeset
  use Ecto.Schema

  schema "join_requests" do
    belongs_to :user, Melange.Users.User
    belongs_to :group, Melange.Groups.Group

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_id, :user_id])
    |> validate_required([:group_id, :user_id])
    |> unique_constraint(:user_id, name: :join_requests_user_id_group_id_index, message: :already_requested)
  end
end
