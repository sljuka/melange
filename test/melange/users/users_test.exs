defmodule Melange.UsersTest do
  @moduledoc """
  Users business logic tests
  """

  use Melange.DataCase

  alias Melange.Fixture
  alias Melange.Repo
  alias Melange.Users
  alias Melange.Users.User

  describe "Users context" do
    alias Melange.Users.User

    @valid_attrs %{
      "email" =>      "mike@mail.com",
      "first_name" => "Mike",
      "last_name" =>  "Tyson",
      "password" =>   "test1234"
    }
    @update_attrs Map.merge(@valid_attrs, %{"first_name" => "Michael"})
    @invalid_attrs %{"email" => nil, "first_name" => "First_name2", "last_name" => "Last_name2"}

    test "list_users/0 returns all users" do
      user = Fixture.user

      assert Users.list_users == [user]
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs, %{})

      assert user.first_name == "Mike"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs, %{})
    end

    test "update_user/2 with valid data updates the user" do
      user = Fixture.user
      assert {:ok, updated_user} = Users.update_user(Map.merge(%{"id" => user.id}, @update_attrs), %{current_user: user})
      assert %User{} = updated_user
      assert updated_user.first_name == "Michael"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = Fixture.user
      assert {:error, %Ecto.Changeset{}} = Users.update_user(Map.merge(%{"id" => user.id}, @invalid_attrs), %{current_user: user})
      assert user == Repo.get!(User, user.id)
    end

    test "delete_user/2 deletes the user" do
      current = Fixture.user
      user = Fixture.user
      assert {:ok, %User{}} = Users.delete_user(%{id: user.id}, %{current_user: current})
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(User, user.id) end
    end

    test "user_changeset/2 returns a user changeset" do
      user = Fixture.user
      assert %Ecto.Changeset{} = Users.user_changeset(user, %{})
    end
  end
end
