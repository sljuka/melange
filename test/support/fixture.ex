defmodule Melange.Fixture do
  alias Melange.Users
  alias Melange.Groups

  @user_default %{
    first_name: "Mike",
    last_name: "Tyson",
    email: "user@mail.com",
    password: "test1234"
  }

  @group_default %{
    name: "New_group"
  }

  def user(), do: user(%{})

  def user(args) do
    random_email_map = Map.merge(@user_default, %{email: "#{random_string(10)}@mail.com"})
    {:ok, user} = Users.create_user(Map.merge(random_email_map, args))
    Map.merge(user, %{password: nil}) # remove virtual field (password)
  end

  def group(), do: group(%{})

  def group(args) do
    owner = user()
    new_args = Map.merge(@group_default, args)
    group(new_args, owner)
  end

  def group(args, user) do
    merge = Map.merge(@group_default, args)
    {:ok, newGroup} = Groups.create_group(merge, %{current_user: user})
    newGroup
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
