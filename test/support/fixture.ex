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
    {:ok, user} = Users.create_user(Map.merge(random_email_map, args))
    Map.merge(user, %{password: nil}) # remove virtual password field
  end

  def group(), do: group(%{})
  def group(args), do: group(args, user())
  def group(args, user) do
    merge = Map.merge(%{name: random_string(10)}, args)
    {:ok, new_group} = Groups.create_group(merge, %{current_user: user})
    new_group
  end

  def role(args, group, user) do
    new_args = Map.merge(%{group_id: group.id}, args)
    Groups.add_role(new_args, %{current_user: user})
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
