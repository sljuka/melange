defmodule Melange.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :group_id, references(:groups, on_delete: :delete_all)
      add :name, :string, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:roles, [:group_id, :name], name: :permissions_group_id_name_index)
  end
end
