defmodule Melange.Groups do
  alias Ecto.Multi
  import Ecto.Query, only: [from: 2]
  alias Melange.Bouncer
  alias Melange.Groups.Group
  alias Melange.Groups.Member
  alias Melange.Repo

  def create_group(args, %{current_user: current_user}) do
    multi =
      Multi.new
      |> Multi.insert(:group, Group.changeset(%Group{owner_id: current_user.id}, args))
      |> Multi.run(:member, fn %{group: group} ->
        %Member{}
          |> Member.changeset(%{group_id: group.id, user_id: current_user.id})
          |> Repo.insert
      end)

    case Repo.transaction(multi) do
      {:ok, %{group: group}} -> {:ok, group}
      {:error, _multi_name, changeset, %{}} -> {:error, changeset}
    end
  end

  def list_groups(_args, context) do
    with :ok <- Bouncer.check_authentication(context)
    do
      Repo.all(Group)
    end
  end

  def update_group(group_id, args, context) do
    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(group_id, context, "update_group")
    do
      group = get_group!(group_id)

      group
      |> Group.changeset(args)
      |> Repo.update
    end
  end

  def get_group!(id), do: Repo.get!(Group, id)

  def get_members(group) do
    Repo.all from member in Member,
      where: member.group_id == ^group.id,
      preload: [:user]
  end

  def changeset(struct, args), do: Group.changeset(struct, args)
end
