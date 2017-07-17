defmodule Melange.Groups do
  alias Ecto.Multi
  import Ecto.Query, only: [from: 2]
  alias Melange.Bouncer
  alias Melange.Groups.Group
  alias Melange.Groups.Member
  alias Melange.Groups.Role
  alias Melange.Groups.MemberRole
  alias Melange.Groups.JoinRequest
  alias Melange.Repo

  def get_group!(id), do: Repo.get!(Group, id)

  def get_members(group) do
    Repo.all from member in Member,
      where: member.group_id == ^group.id,
      preload: [:user]
  end

  def list_groups(_args, context) do
    with :ok <- Bouncer.check_authentication(context)
    do
      Repo.all(Group)
    end
  end

  def create_group(args, %{current_user: current_user}) do
    multi =
      Multi.new
      |> Multi.insert(:group, Group.changeset(%Group{owner_id: current_user.id}, args))
      |> Multi.run(:member, fn %{group: group} ->
        %Member{}
          |> Member.changeset(%{group_id: group.id, user_id: current_user.id})
          |> Repo.insert
      end)
      |> Multi.run(:role, fn %{group: group} ->
        %Role{}
          |> Role.changeset(%{group_id: group.id, name: "owner"})
          |> Repo.insert
      end)
      |> Multi.run(:member_role, fn %{role: role, member: member} ->
        %MemberRole{}
          |> MemberRole.changeset(%{role_id: role.id, member_id: member.id})
          |> Repo.insert
      end)

    case Repo.transaction(multi) do
      {:ok, %{group: group}} -> {:ok, group}
      {:error, _multi_name, changeset, %{}} -> {:error, changeset}
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

  def add_role(args, context) do
    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(args.group_id, context, "add_role")
    do
      %Role{}
      |> Role.changeset(args)
      |> Repo.insert
    end
  end

  def request_join(group_id, context) do
    with :ok <- Bouncer.check_authentication(context)
    do
      %{current_user: current_user} = context
      if is_member?(group_id, current_user.id) do
        {:error, :already_member}
      else
        %JoinRequest{}
        |> JoinRequest.changeset(%{user_id: current_user.id, group_id: group_id})
        |> Repo.insert
      end
    end
  end

  def changeset(struct, args), do: Group.changeset(struct, args)

  defp is_member?(group_id, user_id) do
    query =
      from m in Member,
      where: m.group_id == ^group_id and m.user_id == ^user_id,
      limit: 1,
      select: 1

    case Repo.all(query) do
      [1] -> true
      [] -> false
    end
  end
end
