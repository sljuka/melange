defmodule Melange.Groups.Member do
  alias Melange.Groups.Group
  import Ecto.Changeset
  use Ecto.Schema

  schema "members" do
    belongs_to :user, Melange.Users.User
    belongs_to :group, Melange.Groups.Group

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_id, :user_id])
    |> validate_required([:group_id, :user_id])
  end
end
