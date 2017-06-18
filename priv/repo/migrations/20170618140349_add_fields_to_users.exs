defmodule Melange.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    Melange.Repo.delete_all(Melange.Accounts.User)

    alter table(:accounts_users) do
      remove :name
      add :email, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :password_hash, :string
    end

    create unique_index(:accounts_users, [:email])
  end
end
