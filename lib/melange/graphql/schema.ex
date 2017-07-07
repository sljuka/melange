defmodule Melange.GraphQL.Schema do
  use Absinthe.Schema
  import_types Melange.GraphQL.Types
  alias Melange.GraphQL.Resolvers.User, as: UserResolver

  query do
    field :users, list_of(:user) do
      resolve &UserResolver.list_users/2
    end
  end

  input_object :user_params do
    field :first_name,  :string
    field :last_name,   :string
    field :password,    :string
    field :email,       :string
  end

  mutation do
    field :update_user, type: :user do
      arg :id,   non_null(:integer)
      arg :user, :user_params

      resolve &UserResolver.update_user/2
    end

    field :create_user, type: :user do
      arg :user, :user_params

      resolve &UserResolver.create_user/2
    end
  end
end
