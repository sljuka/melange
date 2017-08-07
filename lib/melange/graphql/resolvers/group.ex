defmodule Melange.GraphQL.Resolvers.Group do
  alias Melange.Groups
  alias Melange.ErrorAdapter

  def list_groups(args, %{context: context}) do
    Groups.list_groups(args, context)
  end

  def create_group(args, %{context: context}) do
    %{group: group_args} = args

    Groups.create_group(group_args, context)
    |> ErrorAdapter.adapt
  end

  def update_group(args, %{context: context}) do
    %{id: id, group: group_args} = args

    Groups.update_group(id, group_args, context)
    |> ErrorAdapter.adapt
  end

  def add_role(%{role: args}, %{context: context}) do
    Groups.add_role(args, context)
    |> ErrorAdapter.adapt
  end

  def request_join(%{id: id}, %{context: context}) do
    Groups.request_join(id, context)
    |> ErrorAdapter.adapt
  end

  def accept_request(%{id: id}, %{context: context}) do
    Groups.accept_request(id, context)
    |> ErrorAdapter.adapt
  end

  def remove_member(%{id: id}, %{context: context}) do
    Groups.remove_member(id, context)
    |> ErrorAdapter.adapt
  end

  def get_owner_member(group, _args, _context) do
    Groups.get_owner_member(group.id)
  end

  def invite_user(args, %{context: context}) do
    Groups.invite_user(args, context)
    |> ErrorAdapter.adapt
  end

  def accept_invite(args, %{context: context}) do
    Groups.accept_invite(args, context)
    |> ErrorAdapter.adapt
  end

  def assign_role(args, %{context: context}) do
    Groups.assign_role(args, context)
    |> ErrorAdapter.adapt
  end

  def fetch_group(args, %{context: context}) do
    Groups.fetch_group(args, context)
  end

  def add_permission(%{permission: permission}, %{context: context}) do
    Groups.add_permission(permission, context)
    |> ErrorAdapter.adapt
  end

  def assign_permission(args, %{context: context}) do
    Groups.assign_permission(args, context)
    |> ErrorAdapter.adapt
  end

  def transfer_ownership(args, %{context: context}) do
    Groups.transfer_ownership(args, context)
    |> ErrorAdapter.adapt
  end
end
