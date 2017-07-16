defmodule Melange.GraphQL.Schema do
  use Absinthe.Schema
  import_types Melange.GraphQL.Types
  alias Melange.GraphQL.Resolvers.User, as: UserResolver
  alias Melange.GraphQL.Resolvers.Group, as: GroupResolver

  query do
    field :users,  list_of(:user),  do: resolve &UserResolver.list_users/2
    field :groups, list_of(:group), do: resolve &GroupResolver.list_groups/2
  end

  input_object :user_params do
    field :first_name,  :string
    field :last_name,   :string
    field :password,    :string
    field :email,       :string
  end

  input_object :group_params do
    field :name,        :string
    field :description, :string
  end

  input_object :role_params do
    field :name,        non_null(:string)
    field :group_id,    non_null(:integer)
    field :description, :string
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

    field :create_group, type: :group do
      arg :group, :group_params

      resolve &GroupResolver.create_group/2
    end

    field :update_group, type: :group do
      arg :id,    non_null(:integer)
      arg :group, :group_params

      resolve &GroupResolver.update_group/2
    end

    field :add_role, type: :role do
      arg :role, :role_params

      resolve &GroupResolver.add_role/2
    end
  end
end
