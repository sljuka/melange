defmodule Melange.GraphQL.Types do
  use Absinthe.Schema.Notation

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
end
