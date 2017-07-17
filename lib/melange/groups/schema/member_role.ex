defmodule Melange.Groups.MemberRole do
  import Ecto.Changeset
  use Ecto.Schema

  schema "member_roles" do
    belongs_to :member, Melange.Groups.Member
    belongs_to :role, Melange.Groups.Role

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:member_id, :role_id])
    |> validate_required([:member_id, :role_id])
  end
end
