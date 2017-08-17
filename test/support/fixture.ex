defmodule Melange.Fixture do
  alias Melange.Users
  alias Melange.Groups

  @user_default %{
    first_name: "Mike",
    last_name: "Tyson",
    email: "user@mail.com",
    password: "test1234"
  }

  def user(), do: user(%{})
  def user(args) do
    random_email_map = Map.merge(@user_default, %{email: "#{random_string(10)}@mail.com"})
    {:ok, user} = Users.create_user(Map.merge(random_email_map, args), %{})
    Map.merge(user, %{password: nil}) # remove virtual password field
  end

  def group(), do: group(%{})
  def group(args), do: group(args, user())
  def group(args, user) do
    merge = Map.merge(%{name: random_string(10)}, args)
    {:ok, new_group} = Groups.create_group(merge, %{current_user: user})
    new_group
  end

  def role(group, args), do: role(user(), group, args)
  def role(user, group, args) do
    new_args = Map.merge(%{group_id: group.id}, args)
    {:ok, role } = Groups.add_role(new_args, %{current_user: user})
    role
  end

  def join_request(group, user) do
    {:ok, request} = Groups.request_join(%{group_id: group.id}, %{current_user: user})
    request
  end

  def member(group), do: member(user(), group)
  def member(user, group) do
    {:ok, member} = Groups.add_member(user.id, group.id)
    member
  end

  def invite(inviter, group, user) do
    {:ok, invite} = Groups.invite_user(
      %{user_id: user.id, group_id: group.id},
      %{current_user: inviter}
    )
    invite
  end

  def permission(group, args), do: permission(user(), group, args)
  def permission(user, group, args) do
    new_args = Map.merge(%{group_id: group.id}, args)
    {:ok, permission} = Groups.add_permission(new_args, %{current_user: user})
    permission
  end

  def role_permission(role, permission) do
    {:ok , rp} = Groups.assign_permission(%{role_id: role.id, permission_id: permission.id}, %{current_user: user()})
    rp
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
