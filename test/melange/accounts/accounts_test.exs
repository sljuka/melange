defmodule Melange.AccountsTest do
  use Melange.DataCase

  alias Melange.Accounts
  alias Melange.Fixture

  describe "Accounts context" do
    alias Melange.Accounts.User

    @valid_attrs %{
      email:      "mike@mail.com",
      first_name: "Mike",
      last_name:  "Tyson",
      password:   "test1234"
    }
    @update_attrs %{email: "updated@mail.com", first_name: "Michael", last_name: "Jordan"}
    @invalid_attrs %{email: nil, first_name: "First_name2", last_name: "Last_name2"}

    test "list_users/0 returns all users" do
      user = Fixture.user

      assert Accounts.list_users == {:ok, [user]}
    end

    test "get_user!/1 returns the user with given id" do
      user = Fixture.user

      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert user.first_name == "Mike"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = Fixture.user
      assert {:ok, updated_user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = updated_user
      assert updated_user.first_name == "Michael"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = Fixture.user
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = Fixture.user
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "update_changeset/2 returns a user changeset" do
      user = Fixture.user
      assert %Ecto.Changeset{} = Accounts.update_changeset(user, %{})
    end

    test "registration_changeset/1 returns a user changeset" do
      user = Fixture.user
      assert %Ecto.Changeset{} = Accounts.registration_changeset(user, %{})
    end
  end
end
