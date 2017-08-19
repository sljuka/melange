defmodule Melange.GraphQL.Resolvers.Group do
  @moduledoc """
  Graphql integration layer for group features
  """

  alias Melange.Groups
  alias Melange.Adapters.GraphQLErrorAdapter, as: ErrorAdapter
  alias Melange.Adapters.ArgsStringifierAdapter, as: ArgsAdapter
  alias Melange.Adapters.GraphQLContextAdapter, as: ContextAdapter

  def list_groups(args, info) do
    context = ContextAdapter.adapt(info)

    Groups.list_groups(args, context)
  end

  def create_group(args, info) do
    context = ContextAdapter.adapt(info)
    adapted_args = ArgsAdapter.adapt(args)
    %{"group" => group_args} = adapted_args

    group_args
    |> Groups.create_group(context)
    |> ErrorAdapter.adapt
  end

  def update_group(args, info) do
    context = ContextAdapter.adapt(info)
    adapted_args = ArgsAdapter.adapt(args)

    %{"id" => id, "group" => group_args} = adapted_args
    merged_args = Map.merge(group_args, %{"id" => id})

    merged_args
    |> Groups.update_group(context)
    |> ErrorAdapter.adapt
  end

  def add_role(%{role: args}, %{context: context}) do
    args
    |> Groups.add_role(context)
    |> ErrorAdapter.adapt
  end

  def request_join(%{id: id}, %{context: context}) do
    %{group_id: id}
    |> Groups.request_join(context)
    |> ErrorAdapter.adapt
  end

  def accept_request(%{id: id}, %{context: context}) do
    id
    |> Groups.accept_request(context)
    |> ErrorAdapter.adapt
  end

  def remove_member(%{id: id}, %{context: context}) do
    id
    |> Groups.remove_member(context)
    |> ErrorAdapter.adapt
  end

  def get_owner_member(group, _args, _context) do
    Groups.get_owner_member(group.id)
  end

  def invite_user(args, %{context: context}) do
    args
    |> Groups.invite_user(context)
    |> ErrorAdapter.adapt
  end

  def accept_invite(args, %{context: context}) do
    args
    |> Groups.accept_invite(context)
    |> ErrorAdapter.adapt
  end

  def assign_role(args, %{context: context}) do
    args
    |> Groups.assign_role(context)
    |> ErrorAdapter.adapt
  end

  def fetch_group(args, %{context: context}) do
    adapted_args = ArgsAdapter.adapt(args)
    adapted_args
    |> Groups.fetch_group(context)
  end

  def add_permission(%{permission: permission}, %{context: context}) do
    permission
    |> Groups.add_permission(context)
    |> ErrorAdapter.adapt
  end

  def assign_permission(args, %{context: context}) do
    args
    |> Groups.assign_permission(context)
    |> ErrorAdapter.adapt
  end

  def transfer_ownership(args, %{context: context}) do
    args
    |> Groups.transfer_ownership(context)
    |> ErrorAdapter.adapt
  end
end
