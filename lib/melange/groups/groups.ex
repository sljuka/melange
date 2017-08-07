defmodule Melange.Groups do
  alias Ecto.Multi
  import Ecto.Query, only: [from: 2]
  alias Melange.Bouncer
  alias Melange.Groups.Group
  alias Melange.Groups.Member
  alias Melange.Groups.Role
  alias Melange.Groups.MemberRole
  alias Melange.Groups.JoinRequest
  alias Melange.Groups.GroupInvite
  alias Melange.Groups.Permission
  alias Melange.Groups.RolePermission
  alias Melange.Repo

  def fetch_group(%{id: id}, _context) do
    {:ok, Repo.get!(Group, id)}
  end

  def fetch_group(%{name: name}, _context) do
    {:ok, Repo.get_by!(Group, name: name)}
  end

  def list_groups(_args, context) do
    with :ok <- Bouncer.check_authentication(context)
    do
      {:ok, Repo.all(Group)}
    end
  end

  def create_group(args, context) do
    with :ok <- Bouncer.check_authentication(context)
    do
      %{current_user: current_user} = context

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
  end

  def update_group(group_id, args, context) do
    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(group_id, context, "update_group")
    do
      group = Repo.get!(Group, group_id)

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
        {:error, "group_id", :already_member}
      else
        %JoinRequest{}
        |> JoinRequest.changeset(%{user_id: current_user.id, group_id: group_id})
        |> Repo.insert
      end
    end
  end

  def accept_request(request_id, context) do
    request = Repo.get!(JoinRequest, request_id)

    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(request.group_id, context, "accept_request")
    do
      Repo.delete(request)
      add_member(request.user_id, request.group_id)
    end
  end

  def remove_member(member_id, context) do
    member = Repo.get!(Member, member_id)
    group_id = member.group_id

    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(group_id, context, "remove_member")
    do
      group = Repo.get!(Group, group_id)
      if group.owner_id === member.user_id do
        {:error, "id", :can_not_remove_owner}
      else
        Repo.delete(member)
        {:ok, group}
      end
    end
  end

  def add_permission(args, context) do
    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(args.group_id, context, "add_permission")
    do
      %Permission{}
      |> Permission.changeset(args)
      |> Repo.insert
    end
  end

  def assign_permission(args, context) do
    role = Repo.get!(Role, args.role_id)
    permission = Repo.get!(Permission, args.permission_id)

    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(role.group_id, context, "assign_permission")
    do
      cond do
        role.group_id != permission.group_id -> {:error, "permission_id", :not_part_of_same_group}
        true ->
          %RolePermission{}
            |> RolePermission.changeset(args)
            |> Repo.insert
      end
    end
  end

  def add_member(user_id, group_id) do
    %Member{}
    |> Member.changeset(%{user_id: user_id, group_id: group_id})
    |> Repo.insert
  end

  def get_owner_member(group_id) do
    group = Repo.get!(Group, group_id)
    {:ok, Repo.get_by!(Member, user_id: group.owner_id)}
  end

  def invite_user(args, context) do
    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(args.group_id, context, "invite_user")
    do
      cond do
        is_member?(args.group_id, args.user_id) ->
          {:error, "user_id", :already_member}
        true ->
          %GroupInvite{}
          |> GroupInvite.changeset(args)
          |> Repo.insert
      end
    end
  end

  def accept_invite(args, context) do
    invite = Repo.get!(GroupInvite, args.invite_id)

    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(invite.group_id, context, "accept_invite")
    do
      cond do
        context.current_user.id != invite.user_id ->
          {:error, "invite_id", :only_accept_own_invite}
        true ->
          Repo.delete(invite)
          add_member(invite.user_id, invite.group_id)
      end
    end
  end

  def assign_role(args, context) do
    member = Repo.get!(Member, args.member_id)
    role = Repo.get!(Role, args.role_id)

    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(member.group_id, context, "assign_role")
    do
      cond do
        member.group_id != role.group_id ->
          {:error, "role_id", :not_part_of_same_group}
        true ->
          %MemberRole{}
            |> MemberRole.changeset(args)
            |> Repo.insert

          {:ok, member}
      end
    end
  end

  def transfer_ownership(args, context) do
    member = Repo.get!(Member, args.member_id)

    with :ok <- Bouncer.check_authentication(context),
         :ok <- Bouncer.check_authorization(member.group_id, context, "transfer_ownership")
    do
      group = Repo.get!(Group, member.group_id)
      cond do
        group.owner_id != context.current_user.id ->
          {:error, "member_id", :only_owner_can_transfer_ownership}
        true ->
          group
            |> Group.changeset(%{owner_id: member.user_id})
            |> Repo.update

          {:ok, member}
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
