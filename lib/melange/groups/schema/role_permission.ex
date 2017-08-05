defmodule Melange.Groups.RolePermission do
  import Ecto.Changeset
  use Ecto.Schema
  alias Melange.Groups.Permission
  alias Melange.Groups.Role

  schema "role_permissions" do
    belongs_to :permission, Permission
    belongs_to :role, Role

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:permission_id, :role_id])
    |> validate_required([:permission_id, :role_id])
  end
end
