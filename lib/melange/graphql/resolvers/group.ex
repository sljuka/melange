defmodule Melange.GraphQL.Resolvers.Group do
  alias Melange.Groups
  alias Melange.GraphQL.Adapters.ErrorAdapter

  def list_groups(args, %{context: context}) do
    {:ok, Groups.list_groups(args, context)}
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
end
