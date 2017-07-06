defmodule Melange.GraphQL.Schema do
  use Absinthe.Schema
  import_types Melange.GraphQL.Types
  alias Melange.GraphQL.Resolvers.User, as: UserResolver

  query do
    field :users, list_of(:user) do
      resolve &UserResolver.list_users/2
    end
  end

  input_object :update_user_params do
    field :name, :string
    field :email, :string
  end

  mutation do
    field :update_user, type: :user do
      arg :user, :update_user_params

      resolve &UserResolver.update_user/2
    end
  end
end
