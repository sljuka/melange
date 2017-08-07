defmodule Melange.GroupsTest do
  alias Melange.Fixture
  alias Melange.Groups
  alias Melange.Groups.Member
  alias Melange.Repo
  import Ecto.Query, only: [from: 2]
  use Melange.DataCase

  describe "Groups resource" do

    test "it allows users to create groups" do
      owner = Fixture.user
      {:ok, group} = Groups.create_group(%{name: "New name"}, %{current_user: owner})

      assert group.owner_id == owner.id
      assert group.name == "New name"
    end

    test "it allows group owners to update group" do
      owner = Fixture.user
      group = Fixture.group(%{}, owner)

      {:ok, group} =
        Groups.update_group(group.id,
                            %{name: "Updated name"},
                            %{current_user: owner})

      assert group.owner_id == owner.id
      assert group.name == "Updated name"
    end

    test "it does not allow unsigned users to update groups" do
      owner = Fixture.user
      group = Fixture.group(%{}, owner)

      res1 = Groups.update_group(group.id, %{name: "Updated name"}, %{current_user: nil})
      res2 = Groups.update_group(group.id, %{name: "Updated name"}, %{})

      assert res1 == {:error, :not_authenticated}
      assert res2 == {:error, :not_authenticated}
    end

    test "it allows signed users to query existing groups" do
      group1 = Fixture.group(%{name: "Group1"})
      group2 = Fixture.group(%{name: "Group2"})
      group3 = Fixture.group(%{name: "Group3"})
      res = Groups.list_groups(%{}, %{current_user: Fixture.user})

      assert res == {:ok, [group1, group2, group3]}
    end

    test "it doesn't allow unsigned users to query other groups in the system" do
      res1 = Groups.list_groups(%{}, %{current_user: nil})

      assert res1 == {:error, :not_authenticated}
    end

    test "it doesn't allow creating a group with already existing name" do
      Fixture.group(%{name: "Group1"})
      {:error, changeset} = Groups.create_group(%{name: "Group1"}, %{current_user: Fixture.user})

      assert changeset.errors[:name] == {"has_been_taken", []}
    end

    test "user who created the group becomes member of that group" do
      owner = Fixture.user
      {:ok, group} = Groups.create_group(%{name: "Group1"}, %{current_user: owner})

      query = from m in Member, where: m.group_id == ^group.id and m.user_id == ^owner.id

      member = Repo.one(query)

      assert member.user_id == owner.id
      assert member.group_id == group.id
    end
  end
end
