defmodule Melange.GraphQL.Types do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Melange.GraphQL.GroupResolver
  alias Melange.Groups
  alias Melange.Users

  object :user do
    field :id,            :id
    field :email,         :string
    field :first_name,    :string
    field :last_name,     :string
    field :owned_groups,  list_of(:group),        resolve: dataloader(Groups.Group)
    field :group_invites, list_of(:group_invite), resolve: dataloader(Groups.GroupInvite)
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
    field :roles,         list_of(:role),         resolve: dataloader(Groups.Role)
    field :members,       list_of(:member),       resolve: dataloader(Groups.Member)
    field :permissions,   list_of(:permission),   resolve: dataloader(Groups.Permission)
    field :join_requests, list_of(:join_request), resolve: dataloader(Groups.JoinRequest)
    field :invites,       list_of(:group_invite), resolve: dataloader(Groups.GroupInvite)
    field :owner,         :member, do: resolve &GroupResolver.get_owner_member/3
  end

  object :member do
    field :id,    :id
    field :user,  :user,          resolve: dataloader(Users.User)
    field :group, :group,         resolve: dataloader(Groups.Group)
    field :roles, list_of(:role), resolve: dataloader(Groups.Role)
  end

  object :role do
    field :id,    :id
    field :name,        :string
    field :description, :string
    field :group, :group, resolve: dataloader(Groups.Group)
  end

  object :join_request do
    field :id,    :id
    field :user,  :user,  resolve: dataloader(Users.User)
    field :group, :group, resolve: dataloader(Groups.Group)
  end

  object :group_invite do
    field :id,    :id
    field :user,  :user,  resolve: dataloader(Users.User)
    field :group, :group, resolve: dataloader(Groups.Group)
  end

  object :permission do
    field :id,          :id
    field :name,        :string
    field :description, :string
    field :group,       :group, resolve: dataloader(Groups.Group)
  end

  object :role_permission do
    field :id, :id
    field :role, :role,  resolve: dataloader(Groups.Role)
    field :permission, :permission,  resolve: dataloader(Groups.Permission)
  end
end
