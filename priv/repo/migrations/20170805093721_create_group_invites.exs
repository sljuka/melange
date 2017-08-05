defmodule Melange.Repo.Migrations.CreateGroupInvites do
  use Ecto.Migration

  def change do
    create table(:group_invites) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:group_invites, [:user_id, :group_id], name: :group_invites_user_id_group_id_index)
  end
end
