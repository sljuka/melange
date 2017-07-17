defmodule Melange.Repo.Migrations.CreateMemberRoles do
  use Ecto.Migration

  def change do
    create table(:member_roles) do
      add :member_id, references(:members, on_delete: :delete_all)
      add :role_id, references(:roles, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:member_roles, [:member_id, :role_id])
  end
end
