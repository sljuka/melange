defmodule Melange.GraphQL.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :email,      :string
    field :first_name, :string
    field :id,         :id
    field :last_name,  :string
  end
end
