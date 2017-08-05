defmodule Melange.Repo.Migrations.CreateRolePermissions do
  use Ecto.Migration

  def change do
    create table(:role_permissions) do
      add :permission_id, references(:permissions, on_delete: :delete_all)
      add :role_id, references(:roles, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:role_permissions, [:permission_id, :role_id], name: :role_permissions_permission_id_role_id_index)
  end
end
