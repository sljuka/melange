defmodule Melange.GraphQL.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Melange.Repo
  alias Melange.GraphQL.Resolvers.Group, as: GroupResolver

  object :user do
    field :id,            :id
    field :email,         :string
    field :first_name,    :string
    field :last_name,     :string
    field :owned_groups,  list_of(:group),        resolve: assoc(:owned_groups)
    field :group_invites, list_of(:group_invite), resolve: assoc(:group_invites)
    field :name, :string do
      resolve fn item, _, _ ->
        {:ok, "#{item.first_name} #{item.last_name}"}
      end
    end
  end

  object :session do
    field :token, :string
  end

  object :group do
    field :id,            :id
    field :name,          :string
    field :description,   :string
    field :roles,         list_of(:role),         resolve: assoc(:roles)
    field :members,       list_of(:member),       resolve: assoc(:members)
    field :permissions,   list_of(:permission),   resolve: assoc(:permissions)
    field :join_requests, list_of(:join_request), resolve: assoc(:join_requests)
    field :invites,       list_of(:group_invite), resolve: assoc(:group_invites)
    field :owner,         :member, do: resolve &GroupResolver.get_owner_member/3
  end

  object :member do
    field :id,    :id
    field :user,  :user,          resolve: assoc(:user)
    field :group, :group,         resolve: assoc(:group)
    field :roles, list_of(:role), resolve: assoc(:roles)
  end

  object :role do
    field :id,    :id
    field :name,        :string
    field :description, :string
    field :group, :group, resolve: assoc(:group)
  end

  object :join_request do
    field :id,    :id
    field :user,  :user,  resolve: assoc(:user)
    field :group, :group, resolve: assoc(:group)
  end

  object :group_invite do
    field :id,    :id
    field :user,  :user,  resolve: assoc(:user)
    field :group, :group, resolve: assoc(:group)
  end

  object :permission do
    field :id,          :id
    field :name,        :string
    field :description, :string
    field :group,       :group, resolve: assoc(:group)
  end
end
