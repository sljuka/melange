defmodule Melange.GraphQL.Schema do
  use Absinthe.Schema
  import_types Melange.GraphQL.Types
  alias Melange.GraphQL.Resolvers.User, as: UserResolver
  alias Melange.GraphQL.Resolvers.Group, as: GroupResolver

  query do
    field :users,  list_of(:user),  do: resolve &UserResolver.list_users/2
    field :groups, list_of(:group), do: resolve &GroupResolver.list_groups/2
    field :group,  :group do
      arg :id,     :id
      arg :name,   :string

      resolve &GroupResolver.fetch_group/2
    end
    field :user, type: :user do
      arg :email, non_null(:string)

      resolve &UserResolver.search/2
    end
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
    field :group_id,    non_null(:id)
    field :description, :string
  end

  input_object :permission_params do
    field :name,        non_null(:string)
    field :group_id,    non_null(:id)
    field :description, :string
  end

  mutation do
    field :update_user, type: :user do
      arg :id,   non_null(:id)
      arg :user, non_null(:user_params)

      resolve &UserResolver.update_user/2
    end

    field :create_user, type: :user do
      arg :user, non_null(:user_params)

      resolve &UserResolver.create_user/2
    end

    field :create_group, type: :group do
      arg :group, non_null(:group_params)

      resolve &GroupResolver.create_group/2
    end

    field :update_group, type: :group do
      arg :id,    non_null(:id)
      arg :group, non_null(:group_params)

      resolve &GroupResolver.update_group/2
    end

    field :add_role, type: :role do
      arg :role, non_null(:role_params)

      resolve &GroupResolver.add_role/2
    end

    field :request_join, type: :join_request do
      arg :id, non_null(:id)

      resolve &GroupResolver.request_join/2
    end

    field :accept_request, type: :member do
      arg :id, non_null(:id)

      resolve &GroupResolver.accept_request/2
    end

    field :remove_member, type: :group do
      arg :id, non_null(:id)

      resolve &GroupResolver.remove_member/2
    end

    field :login, type: :session do
      arg :email,    non_null(:string)
      arg :password, non_null(:string)

      resolve &UserResolver.login/2
    end

    field :invite_user, type: :group_invite do
      arg :group_id, non_null(:id)
      arg :user_id,  non_null(:id)

      resolve &GroupResolver.invite_user/2
    end

    field :accept_invite, type: :member do
      arg :invite_id, non_null(:id)

      resolve &GroupResolver.accept_invite/2
    end

    field :assign_role, type: :member do
      arg :role_id, non_null(:id)
      arg :member_id, non_null(:id)

      resolve &GroupResolver.assign_role/2
    end

    field :add_permission, type: :permission do
      arg :permission, non_null(:permission_params)

      resolve &GroupResolver.add_permission/2
    end
  end
end
