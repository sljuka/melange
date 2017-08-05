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
    |> unique_constraint(:permission_id, name: :role_permissions_permission_id_role_id_index, message: "the permission has already been assigned to the role")
  end
end
