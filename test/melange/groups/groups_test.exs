defmodule Melange.GroupsTest do
  alias Melange.Fixture
  alias Melange.Groups
  alias Melange.Groups.Member
  alias Melange.Repo
  import Ecto.Query, only: [from: 2]
  use Melange.DataCase

  describe "Groups" do

    test "users can create groups" do
      owner = Fixture.user
      {:ok, group} = Groups.create_group(%{name: "New name"}, %{current_user: owner})

      assert group.owner_id == owner.id
      assert group.name == "New name"
    end

    test "group owner can update group data" do
      owner = Fixture.user
      group = Fixture.group(%{}, owner)

      {:ok, group} =
        Groups.update_group(group.id,
                            %{name: "Updated name"},
                            %{current_user: owner})

      assert group.owner_id == owner.id
      assert group.name == "Updated name"
    end

    test "unauthenticated users can't update groups" do
      owner = Fixture.user
      group = Fixture.group(%{}, owner)

      res1 = Groups.update_group(group.id, %{name: "Updated name"}, %{current_user: nil})
      res2 = Groups.update_group(group.id, %{name: "Updated name"}, %{})

      assert res1 == {:error, "User not authenticated"}
      assert res2 == {:error, "User not authenticated"}
    end

    test "authenticated users can list existing groups" do
      group1 = Fixture.group(%{name: "Group1"})
      group2 = Fixture.group(%{name: "Group2"})
      group3 = Fixture.group(%{name: "Group3"})
      res = Groups.list_groups(%{}, %{current_user: Fixture.user})

      assert res == [group1, group2, group3]
    end

    test "unauthenticated users can't query other groups in the system" do
      res1 = Groups.list_groups(%{}, %{current_user: nil})

      assert res1 == {:error, "User not authenticated"}
    end

    test "group names are unique" do
      Fixture.group(%{name: "Group1"})
      {:error, changeset} = Groups.create_group(%{name: "Group1"}, %{current_user: Fixture.user})

      assert changeset.errors[:name] == {"has already been taken", []}
    end

    test "user who created the group becomes member of that group" do
      owner = Fixture.user
      {:ok, group} = Groups.create_group(%{name: "Group1"}, %{current_user: owner})

      query = from m in Member, where: m.group_id == ^group.id and m.user_id == ^owner.id

      member = Repo.one(query)

      assert member.user_id == owner.id
      assert member.group_id == group.id
    end

    @tag :pending
    test "user can add new user roles in group with right permissions" do
    end

    @tag :pending
    test "user gets all permissions (super_user role) in group he created" do
    end

    @tag :pending
    test "user can assign roles to other group members with right permission" do
    end

    @tag :pending
    test "user can add new permissions to an existing role" do
    end

    @tag :pending
    test "users can't modify a group if they don't have the right permission" do
    end

    @tag :pending
    test "User can modify a group when another member gives him permission" do
    end
  end
end
