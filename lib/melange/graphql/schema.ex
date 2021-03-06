defmodule Melange.GraphQL.Schema do
  use Absinthe.Schema
  import_types Melange.GraphQL.Types
  alias Melange.GraphQL.UserResolver
  alias Melange.GraphQL.GroupResolver
  alias Melange.Groups.{
    Group,
    GroupInvite,
    Role,
    Member,
    Permission,
    JoinRequest
  }
  alias Melange.Users.User

  def ecto_query(queryable, _params) do
    queryable
  end

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Group, Dataloader.Ecto.new(Melange.Repo, query: &ecto_query/2))
      |> Dataloader.add_source(GroupInvite, Dataloader.Ecto.new(Melange.Repo, query: &ecto_query/2))
      |> Dataloader.add_source(Role, Dataloader.Ecto.new(Melange.Repo, query: &ecto_query/2))
      |> Dataloader.add_source(Member, Dataloader.Ecto.new(Melange.Repo, query: &ecto_query/2))
      |> Dataloader.add_source(Permission, Dataloader.Ecto.new(Melange.Repo, query: &ecto_query/2))
      |> Dataloader.add_source(JoinRequest, Dataloader.Ecto.new(Melange.Repo, query: &ecto_query/2))
      |> Dataloader.add_source(User, Dataloader.Ecto.new(Melange.Repo, query: &ecto_query/2))
  
    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    field :users,  list_of(:user),  do: resolve &UserResolver.list_users/2
    field :groups, list_of(:group), do: resolve &GroupResolver.list_groups/2
    field :group,  :group do
      arg :id,     :id
      arg :name,   :string

      resolve &GroupResolver.fetch_group/2
    end
    field :current_user, :user, do: resolve &UserResolver.current_user/2
    field :user, :user do
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

    field :assign_permission, type: :role_permission do
      arg :permission_id, non_null(:id)
      arg :role_id, non_null(:id)

      resolve &GroupResolver.assign_permission/2
    end

    field :transfer_ownership, type: :member do
      arg :member_id, non_null(:id)

      resolve &GroupResolver.transfer_ownership/2
    end
  end
end
