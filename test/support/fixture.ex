defmodule Melange.Fixture do
  alias Melange.Accounts

  @user_default %{
    first_name: "First_name",
    last_name: "Last_name",
    email: "some@mail.com",
    password: "test"
  }

  def user(), do: user(%{})
  def user(map) do
    {:ok, user} = Accounts.create_user(Map.merge(@user_default, map))
    Map.merge(user, %{password: nil}) # remove virtual field (password)
  end
end