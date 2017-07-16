defmodule Melange.GraphQL.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Melange.Repo

  object :user do
    field :email,      :string
    field :first_name, :string
    field :id,         :id
    field :last_name,  :string
    field :name, :string do
      resolve fn item, _, _ ->
        {:ok, "#{item.first_name} #{item.last_name}"}
      end
    end
  end

  object :group do
    field :name,        non_null(:string)
    field :description, :string
    field :owner,       :user,            resolve: assoc(:owner)
    field :members,     list_of(:member), resolve: assoc(:members)
  end

  object :member do
    field :user,  :user,  resolve: assoc(:user)
    field :group, :group, resolve: assoc(:group)
  end

  object :role do
    field :name,        :string
    field :description, :string
    field :group, :group, resolve: assoc(:group)
  end
end
