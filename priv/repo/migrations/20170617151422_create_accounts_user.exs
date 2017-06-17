defmodule Melange.Repo.Migrations.CreateMelange.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :name, :string

      timestamps()
    end

  end
end
