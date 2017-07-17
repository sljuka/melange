defmodule Melange.Repo.Migrations.CreateJoinRequests do
  use Ecto.Migration

  def change do
    create table(:join_requests) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:join_requests, [:user_id, :group_id])
  end
end
