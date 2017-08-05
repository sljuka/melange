defmodule Melange.GraphQL.Resolvers.GroupTest do
  alias Melange.Fixture
  alias Melange.Groups
  use Melange.Web.ConnCase

  describe "Groups resource" do
    @tag :current
    @tag token_login_as: "pera@mail.com"
    test "it allows users to fetch groups by name", %{conn: conn, user: _user} do
      group = Fixture.group

      query = """
      {
        group(name: "#{group.name}") {
          id
          name
        }
      }
      """

      assert_gql_data conn, query, %{
        "group" => %{
          "id"   => "#{group.id}",
          "name" => group.name
        }
      }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows users to fetch group by id", %{conn: conn, user: _user} do
      group = Fixture.group

      query = """
      {
        group(id: #{group.id}) {
          name
          description
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "group" => %{
            "name" => group.name,
            "description" => group.description
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows signed users to create groups", %{conn: conn, user: _user} do
      query = """
      mutation {
        create_group(group: {name: "Company", description: "Test description"}) {
          name
          description
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "create_group" => %{
            "name" => "Company",
            "description" => "Test description"
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it does not allow groups with same names", %{conn: conn, user: _user} do
      Fixture.group(%{name: "NewName"})

      query = """
      mutation {
        create_group(group: {name: "NewName"}) {
          name
          description
        }
      }
      """

      assert_gql_error_map conn, query, [
        %{"name" => %{"details" => %{}, "message" => "has already been taken"}}
      ]
    end

    @tag token_login_as: "pera@mail.com"
    test "it makes the user who created the group that group's owner", %{conn: conn, user: user} do
      query = """
      mutation {
        create_group(group: {name: "Company", description: "Test description"}) {
          name
          owner {
            user {
              email
            }
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{"create_group" => %{
          "name" => "Company",
          "owner" => %{
            "user" => %{
              "email" => user.email
            }
          }
        }}
    end

    @tag token_login_as: "pera@mail.com"
    test "it makes the user who created the group that group's member", %{conn: conn, user: user} do
      query = """
      mutation {
        create_group(group: {name: "Company"}) {
          name
          members {
            user {
              email
            }
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "create_group" => %{
            "name" => "Company",
            "members" => [
              %{"user" => %{"email" => user.email}}
            ]
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows group owner to update group data", %{conn: conn, user: user} do
      group = Fixture.group(%{name: "Name", description: "Description"}, user)

      query = """
      mutation {
        update_group(id: #{group.id}, group: {name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "update_group" => %{
            "name" => "NewName",
            "description" => "New description"
          }
        }
    end

    test "it does not allow unsigned users to update groups", %{conn: conn} do
      group = Fixture.group()

      query = """
      mutation {
        update_group(id: #{group.id}, group: {name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      assert_gql_not_authenticated_error conn, query
    end

    @tag token_login_as: "pera@mail.com"
    test "signed users can query other groups in the system", %{conn: conn, user: _user} do
      group1 = Fixture.group()
      group2 = Fixture.group()
      group3 = Fixture.group()

      query = """
      {
        groups {
          name
        }
      }
      """

      assert_gql_data conn, query, %{
        "groups" => [
          %{"name" => group1.name},
          %{"name" => group2.name},
          %{"name" => group3.name}
        ]
      }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows users to add new user roles to their groups", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)

      query = """
      mutation {
        add_role(role: {group_id: #{group.id}, name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "add_role" => %{
            "name" => "NewName",
            "description" => "New description"
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it does not allow roles with same name to be in the same group", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)
      Fixture.role(%{name: "test"}, group, user)

      query = """
      mutation {
        add_role(role: {group_id: #{group.id}, name: "test"}) {
          name
          description
        }
      }
      """

      assert_gql_error_map conn, query, [
        %{"name" => %{"details" => %{}, "message" => "has already been taken"}}
      ]
    end

    @tag token_login_as: "pera@mail.com"
    test "it creates a 'owner' role and assigns it to the group creator when user creates a group", %{conn: conn, user: user} do
      query = """
      mutation {
        create_group(group: {name: "Company"}) {
          roles {
            name
          }
          members {
            user {
              email
            }
            roles {
              name
            }
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "create_group" => %{
            "roles" => [%{"name" => "owner"}],
            "members" => [
              %{
                "user" => %{"email" => user.email},
                "roles" => [%{"name" => "owner"}]
              }
            ]
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows users to request to join a group", %{conn: conn, user: user} do
      owner = Fixture.user
      group = Fixture.group(%{name: "Name", description: "Description"}, owner)

      query = """
      mutation {
        request_join(id: #{group.id}) {
          group {
            name
          }
          user {
            email
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "request_join" => %{
            "group" => %{"name" => "Name"},
            "user" => %{"email" => user.email}
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it responds with an error in case user requests to join a group in which they are already a member", %{conn: conn, user: user} do
      group = Fixture.group(%{name: "Name", description: "Description"}, user)

      query = """
      mutation {
        request_join(id: #{group.id}) {
          group {
            name
          }
          user {
            email
          }
        }
      }
      """

      assert_gql_error conn, query, ~r/In field "request_join": already_member/
    end

    @tag token_login_as: "pera@mail.com"
    test "it responds with an error when user tries to join a group in which he already sent a join requests", %{conn: conn, user: user} do
      owner = Fixture.user
      group = Fixture.group(%{name: "Name"}, owner)
      Fixture.join_request(group, user)

      query = """
      mutation {
        request_join(id: #{group.id}) {
          group {
            name
          }
          user {
            email
          }
        }
      }
      """

      assert_gql_error_map conn, query, [
        %{"user_id" => %{"details" => %{}, "message" => "already requested to join this group"}}
      ]
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows users to accept join requests, which adds new member to the group and deletes the join request", %{conn: conn, user: user} do
      owner = Fixture.user
      group = Fixture.group(%{name: "Name"}, owner)
      join_request = Fixture.join_request(group, user)

      query = """
      mutation {
        accept_request(id: #{join_request.id}) {
          user {
            email
          }
          group {
            name
            join_requests {
              id
            }
            members {
              user {
                email
              }
            }
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "accept_request" => %{
            "group" => %{
              "name" => "Name",
              "join_requests" => [],
              "members" => [
                %{"user" => %{"email" => owner.email}},
                %{"user" => %{"email" => user.email}}
              ]
            },
            "user" => %{"email" => user.email}
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows group members to remove other members from the group", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)
      member1 = Fixture.member(group)
      member2 = Fixture.member(group)
      member3 = Fixture.member(group)

      query = """
      mutation {
        remove_member(id: #{member3.id}) {
          members {
            user {
              id
            }
          }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "remove_member" => %{
            "members" => [
              %{"user" => %{"id" => "#{user.id}"}},
              %{"user" => %{"id" => "#{member1.user_id}"}},
              %{"user" => %{"id" => "#{member2.user_id}"}}
            ]
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it doesn't allow group members to remove group owner from group members", %{conn: conn, user: user} do
      owner = Fixture.user
      group = Fixture.group(%{}, owner)
      Fixture.member(user, group)
      {:ok, owner_member} = Groups.get_owner_member(group.id)

      query = """
      mutation {
        remove_member(id: #{owner_member.id}) {
          members {
            user {
              id
            }
          }
        }
      }
      """

      assert_gql_error conn, query, ~r/In field "remove_member": can_not_remove_owner/
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows to query group owner from group", %{conn: conn, user: user} do
      owner = Fixture.user
      group = Fixture.group(%{}, owner)
      Fixture.member(user, group)

      query = """
      {
        groups {
          owner {
            user {
              email
            }
          }
          members {
            user {
              email
            }
          }
        }
      }
      """

      assert_gql_data conn, query, %{
        "groups" => [
          %{
            "owner" => %{"user" => %{"email" => owner.email}},
            "members" => [
              %{"user" => %{"email" => owner.email}},
              %{"user" => %{"email" => user.email}}
            ]
          }
        ]
      }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows group members to invite other users to join a group", %{conn: conn, user: user} do
      invitee = Fixture.user
      group = Fixture.group(%{}, user)

      query = """
      mutation {
        invite_user(group_id: #{group.id}, user_id: #{invitee.id}) {
          user { email }
          group { name }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "invite_user" => %{
            "user" => %{"email" => invitee.email},
            "group" => %{"name" => group.name}
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it does not allow same user to be invited to the group multiple times", %{conn: conn, user: user} do
      invitee = Fixture.user
      group = Fixture.group(%{}, user)
      Fixture.invite(user, group, invitee)

      query = """
      mutation {
        invite_user(group_id: #{group.id}, user_id: #{invitee.id}) {
          user { email }
          group { name }
        }
      }
      """

      assert_gql_error_map conn, query, [
        %{
          "user_id" => %{
            "details" => %{},
            "message" => "user has already been invited to join the group"
          }
        }
      ]
    end

    @tag token_login_as: "pera@mail.com"
    test "it does not allow inviting users which are already members of the group", %{conn: conn, user: user} do
      invitee = Fixture.user
      group = Fixture.group(%{}, user)
      Fixture.member(invitee, group)

      query = """
      mutation {
        invite_user(group_id: #{group.id}, user_id: #{invitee.id}) {
          user { email }
          group { name }
        }
      }
      """

      assert_gql_error conn, query, ~r/In field "invite_user": already_a_member_of_group/
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows users to accept group invitations", %{conn: conn, user: user} do
      owner = Fixture.user
      group = Fixture.group(%{}, owner)
      invite = Fixture.invite(owner, group, user)

      query = """
      mutation {
        accept_invite(invite_id: #{invite.id}) {
          user { email }
          group { name }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "accept_invite" => %{
            "user" => %{"email" => user.email},
            "group" => %{"name" => group.name}
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows users to accept only their invitations", %{conn: conn, user: user} do
      invitee = Fixture.user
      group = Fixture.group(%{}, user)
      invite = Fixture.invite(user, group, invitee)

      query = """
      mutation {
        accept_invite(invite_id: #{invite.id}) {
          user { email }
          group { name }
        }
      }
      """

      assert_gql_error conn, query, ~r/In field "accept_invite": Only user who is invited can accept invitation/
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows members to assign roles to other group members", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)
      member = Fixture.member(group)
      role = Fixture.role(%{name: "New role"}, group, user)

      query = """
      mutation {
        assign_role(member_id: #{member.id}, role_id: #{role.id}) {
          group { name }
          user { id }
          roles { name }
        }
      }
      """

      assert_gql_data conn, query,
        %{
          "assign_role" => %{
            "group" => %{"name" => group.name},
            "user" => %{"id" => "#{member.user_id}"},
            "roles" => [%{"name" => role.name}]
          }
        }
    end

    @tag token_login_as: "pera@mail.com"
    test "it allows assigning roles to members who are part of the same group", %{conn: conn, user: user} do
      group = Fixture.group(%{}, user)
      anotherGroup = Fixture.group()
      member = Fixture.member(group)
      role = Fixture.role(%{name: "New role"}, anotherGroup, user)

      query = """
      mutation {
        assign_role(member_id: #{member.id}, role_id: #{role.id}) {
          group { name }
          user { id }
          roles { name }
        }
      }
      """

      assert_gql_error conn, query, ~r/In field "assign_role": Submitted role and member are not part of the same group/
    end

    @tag :pending
    test "it allows members to add new permissions to an existing role" do
    end

    @tag :pending
    test "it doesn't allow members to modify group if they don't have the right permission" do
    end

    @tag :pending
    test "it allows members to modify a group when another member gives them permission via role" do
    end

    @tag :pending
    test "it allows group owner to transfer ownership to another group member" do
    end
  end
end
