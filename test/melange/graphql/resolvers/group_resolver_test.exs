defmodule Melange.GraphQL.GroupResolverTest do
  alias Melange.Fixture
  alias Melange.Groups
  use Melange.ResolverCase
  alias Melange.GraphQL.Schema

  describe "Groups resource" do
    test "it allows users to fetch groups by name" do
      group = Fixture.group

      query = """
      {
        group(name: "#{group.name}") {
          id
          name
        }
      }
      """

      %{ data: data } = Absinthe.run!(query, Schema)
      assert data == %{
        "group" => %{
          "id"   => "#{group.id}",
          "name" => group.name
        }
      }
    end

    test "it allows users to fetch group by id" do
      group = Fixture.group

      query = """
      {
        group(id: #{group.id}) {
          name
          description
        }
      }
      """

      %{ data: data } = Absinthe.run!(query, Schema)
      assert data == %{
        "group" => %{
          "name" => group.name,
          "description" => group.description
        }
      }
    end

    test "it allows signed users to create groups" do
      user = Fixture.user
      query = """
      mutation {
        create_group(group: {name: "Company", description: "Test description"}) {
          name
          description
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        "create_group" => %{
          "name" => "Company",
          "description" => "Test description"
        }
      }
    end

    test "it does not allow groups with same names" do
      user = Fixture.user
      Fixture.group(%{name: "NewName"})

      query = """
      mutation {
        create_group(group: {name: "NewName"}) {
          name
          description
        }
      }
      """

      %{errors: [%{error: error}]} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert error == [%{
        field: :name,
        message: "Value has already been assigned to another record",
        short_message: "has_been_taken"
      }]
    end

    test "it makes the user who created the group that group's owner" do
      current_user = Fixture.user

      query = """
      mutation {
        create_group(group: {name: "Company", description: "Test description"}) {
          name
          owner {
            user { email }
          }
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: current_user}])
      assert data == %{
        "create_group" => %{
          "name" => "Company",
          "owner" => %{
            "user" => %{
              "email" => current_user.email
            }
          }
        }
      }
    end

    test "it makes the user who created the group that group's member" do
      user = Fixture.user
      query = """
      mutation {
        create_group(group: {name: "Company"}) {
          name
          members {
            user { email }
          }
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        "create_group" => %{
          "name" => "Company",
          "members" => [
            %{"user" => %{"email" => user.email}}
          ]
        }
      }
    end

    test "it allows group owner to update group data" do
      user = Fixture.user
      group = Fixture.group(%{name: "Name", description: "Description"}, user)

      query = """
      mutation {
        update_group(id: #{group.id}, group: {name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        "update_group" => %{
          "name" => "NewName",
          "description" => "New description"
        }
      }
    end

    test "it does not allow unsigned users to update groups" do
      group = Fixture.group()

      query = """
      mutation {
        update_group(id: #{group.id}, group: {name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      %{errors: [%{error: [data]}]} = Absinthe.run!(query, Schema)
      assert data == %{
        message: "User is not authenticated",
        field: "",
        short_message: :not_authenticated
      }
    end

    test "signed users can query other groups in the system" do
      user = Fixture.user
      group1 = Fixture.group()
      group2 = Fixture.group()
      group3 = Fixture.group()

      query = """
      {
        groups { name }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        "groups" => [
          %{"name" => group1.name},
          %{"name" => group2.name},
          %{"name" => group3.name}
        ]
      }
    end

    test "it allows users to add new user roles to their groups" do
      user = Fixture.user
      group = Fixture.group(%{}, user)

      query = """
      mutation {
        add_role(role: {group_id: #{group.id}, name: "NewName", description: "New description"}) {
          name
          description
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        "add_role" => %{
          "name" => "NewName",
          "description" => "New description"
        }
      }
    end

    test "it does not allow roles with same name to be in the same group" do
      user = Fixture.user
      group = Fixture.group(%{}, user)
      Fixture.role(user, group, %{name: "test"})

      query = """
      mutation {
        add_role(role: {group_id: #{group.id}, name: "test"}) {
          name
          description
        }
      }
      """

      %{errors: [%{error: [data]}]} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        field: :name,
        message: "Value has already been assigned to another record",
        short_message: "has_been_taken"
      }
    end

    test "it creates a 'owner' role and assigns it to the group creator when user creates a group" do
      user = Fixture.user
      query = """
      mutation {
        create_group(group: {name: "Company"}) {
          roles { name }
          members {
            user { email }
            roles { name }
          }
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
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

    test "it allows users to request to join a group" do
      current_user = Fixture.user
      owner = Fixture.user
      group = Fixture.group(%{name: "Name", description: "Description"}, owner)

      query = """
      mutation {
        request_join(id: #{group.id}) {
          group { name }
          user { email }
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: current_user}])
      assert data == %{
        "request_join" => %{
          "group" => %{"name" => "Name"},
          "user" => %{"email" => current_user.email}
        }
      }
    end

    test "it responds with an error in case user requests to join a group in which they are already a member" do
      user = Fixture.user
      group = Fixture.group(%{name: "Name", description: "Description"}, user)

      query = """
      mutation {
        request_join(id: #{group.id}) {
          group { name }
          user { email }
        }
      }
      """

      %{errors: [%{error: [data]}]} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        field: :group_id,
        short_message: :already_member,
        message: "User can't join the group since he is already member of that group"
      }
    end

    test "it responds with an error when user tries to join a group in which he already sent a join requests" do
      user = Fixture.user
      owner = Fixture.user
      group = Fixture.group(%{name: "Name"}, owner)
      Fixture.join_request(group, user)

      query = """
      mutation {
        request_join(id: #{group.id}) {
          group { name }
          user { email }
        }
      }
      """

      %{errors: [%{error: [data]}]} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        field: :user_id,
        message: "User already requested to join the group",
        short_message: :already_requested
      }
    end

    test "it allows users to accept join requests, which adds new member to the group and deletes the join request" do
      user = Fixture.user
      owner = Fixture.user
      group = Fixture.group(%{name: "Name"}, owner)
      join_request = Fixture.join_request(group, user)

      query = """
      mutation {
        accept_request(id: #{join_request.id}) {
          user { email }
          group {
            name
            join_requests { id }
            members {
              user { email }
            }
          }
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
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

    test "it allows group members to remove other members from the group" do
      user = Fixture.user
      group = Fixture.group(%{}, user)
      member1 = Fixture.member(group)
      member2 = Fixture.member(group)
      member3 = Fixture.member(group)

      query = """
      mutation {
        remove_member(id: #{member3.id}) {
          members {
            user { id }
          }
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        "remove_member" => %{
          "members" => [
            %{"user" => %{"id" => "#{user.id}"}},
            %{"user" => %{"id" => "#{member1.user_id}"}},
            %{"user" => %{"id" => "#{member2.user_id}"}}
          ]
        }
      }
    end

    test "it doesn't allow group members to remove group owner from group" do
      user = Fixture.user
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

      %{errors: [%{error: [data]}]} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        field: :id,
        message: "Owner can't be removed from group members",
        short_message: :can_not_remove_owner
      }
    end

    test "it allows to query group owner from group" do
      user = Fixture.user
      owner = Fixture.user
      group = Fixture.group(%{}, owner)
      Fixture.member(user, group)

      query = """
      {
        groups {
          owner {
            user { email }
          }
          members {
            user { email }
          }
        }
      }
      """

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
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

    @tag :current
    test "it allows group members to invite other users to join a group" do
      user = Fixture.user
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

      %{data: data} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        "invite_user" => %{
          "user" => %{"email" => invitee.email},
          "group" => %{"name" => group.name}
        }
      }
    end

    @tag :current
    test "it does not allow same user to be invited to the group multiple times" do
      user = Fixture.user
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

      %{errors: [%{error: [data]}]} = Absinthe.run!(query, Schema, [context: %{current_user: user}])
      assert data == %{
        field: :user_id,
        message: "User has already been invited to join the group",
        short_message: :user_already_invited
      }
    end

    # @tag :token_login
    # test "it does not allow inviting users which are already members of the group", %{conn: conn, user: user} do
    #   invitee = Fixture.user
    #   group = Fixture.group(%{}, user)
    #   Fixture.member(invitee, group)

    #   query = """
    #   mutation {
    #     invite_user(group_id: #{group.id}, user_id: #{invitee.id}) {
    #       user { email }
    #       group { name }
    #     }
    #   }
    #   """

    #   assert_gql_error_data conn, query, [%{
    #     "field" => "user_id",
    #     "message" => "User can't join the group since he is already member of that group",
    #     "short_message" => "already_member"
    #   }]
    # end

    # @tag :token_login
    # test "it allows users to accept group invitations", %{conn: conn, user: user} do
    #   owner = Fixture.user
    #   group = Fixture.group(%{}, owner)
    #   invite = Fixture.invite(owner, group, user)

    #   query = """
    #   mutation {
    #     accept_invite(invite_id: #{invite.id}) {
    #       user { email }
    #       group { name }
    #     }
    #   }
    #   """

    #   assert_gql_data conn, query,
    #     %{
    #       "accept_invite" => %{
    #         "user" => %{"email" => user.email},
    #         "group" => %{"name" => group.name}
    #       }
    #     }
    # end

    # @tag :token_login
    # test "it allows users to accept only their invitations", %{conn: conn, user: user} do
    #   invitee = Fixture.user
    #   group = Fixture.group(%{}, user)
    #   invite = Fixture.invite(user, group, invitee)

    #   query = """
    #   mutation {
    #     accept_invite(invite_id: #{invite.id}) {
    #       user { email }
    #       group { name }
    #     }
    #   }
    #   """

    #   assert_gql_error_data conn, query, [%{
    #     "field" => "invite_id",
    #     "message" => "User can accept only his own group invites",
    #     "short_message" => "only_accept_own_invite"
    #   }]
    # end

    # @tag :token_login
    # test "it allows members to assign roles to other group members", %{conn: conn, user: user} do
    #   group = Fixture.group(%{}, user)
    #   member = Fixture.member(group)
    #   role = Fixture.role(user, group, %{name: "New role"})

    #   query = """
    #   mutation {
    #     assign_role(member_id: #{member.id}, role_id: #{role.id}) {
    #       group { name }
    #       user { id }
    #       roles { name }
    #     }
    #   }
    #   """

    #   assert_gql_data conn, query,
    #     %{
    #       "assign_role" => %{
    #         "group" => %{"name" => group.name},
    #         "user" => %{"id" => "#{member.user_id}"},
    #         "roles" => [%{"name" => role.name}]
    #       }
    #     }
    # end

    # @tag :token_login
    # test "it allows assigning roles to members who are part of the same group", %{conn: conn, user: user} do
    #   group = Fixture.group(%{}, user)
    #   anotherGroup = Fixture.group()
    #   member = Fixture.member(group)
    #   role = Fixture.role(user, anotherGroup, %{name: "New role"})

    #   query = """
    #   mutation {
    #     assign_role(member_id: #{member.id}, role_id: #{role.id}) {
    #       group { name }
    #       user { id }
    #       roles { name }
    #     }
    #   }
    #   """

    #   assert_gql_error_data conn, query, [%{
    #     "field" => "role_id",
    #     "message" => "Selected records are not part of the same group",
    #     "short_message" => "not_part_of_same_group"
    #   }]
    # end

    # @tag :token_login
    # test "it is able to add new permissions to group (usually done by system)", %{conn: conn, user: _user} do
    #   group = Fixture.group()

    #   query = """
    #   mutation {
    #     add_permission(permission: {group_id: #{group.id}, name: "test", description: "test test test"}) {
    #       group { name }
    #       name
    #       description
    #     }
    #   }
    #   """

    #   assert_gql_data conn, query,
    #     %{
    #       "add_permission" => %{
    #         "group" => %{"name" => group.name},
    #         "name" => "test",
    #         "description" => "test test test"
    #       }
    #     }
    # end

    # @tag :token_login
    # test "it allows members to assign permissions to roles", %{conn: conn, user: _user} do
    #   group = Fixture.group(%{name: "test-group"})
    #   role = Fixture.role(group, %{name: "test-role"})
    #   permission = Fixture.permission(group, %{name: "test-permission"})

    #   query = """
    #   mutation {
    #     assign_permission(permission_id: #{permission.id}, role_id: #{role.id}) {
    #       permission { name }
    #       role { name }
    #     }
    #   }
    #   """

    #   assert_gql_data conn, query,
    #     %{
    #       "assign_permission" => %{
    #         "permission" => %{"name" => permission.name},
    #         "role" =>       %{"name" => role.name}
    #       }
    #     }
    # end

    # @tag :token_login
    # test "it doesn't allow assigning same permissions to same role multiple times", %{conn: conn, user: _user} do
    #   group = Fixture.group(%{name: "test-group"})
    #   role = Fixture.role(group, %{name: "test-role"})
    #   permission = Fixture.permission(group, %{name: "test-permission"})
    #   Fixture.role_permission(role, permission)

    #   query = """
    #   mutation {
    #     assign_permission(permission_id: #{permission.id}, role_id: #{role.id}) {
    #       permission { name }
    #       role { name }
    #     }
    #   }
    #   """

    #   assert_gql_error_data conn, query, [%{
    #     "field" => "permission_id",
    #     "message" => "Permission has already been assigned to role",
    #     "short_message" => "permission_already_assigned_to_role"
    #   }]
    # end

    # @tag :token_login
    # test "it allows assigning permissions only to roles which belong in same group", %{conn: conn, user: _user} do
    #   group = Fixture.group(%{name: "test-group"})
    #   anotherGroup = Fixture.group(%{name: "another-group"})
    #   role = Fixture.role(group, %{name: "test-role"})
    #   permission = Fixture.permission(anotherGroup, %{name: "test-permission"})

    #   query = """
    #   mutation {
    #     assign_permission(permission_id: #{permission.id}, role_id: #{role.id}) {
    #       permission { name }
    #       role { name }
    #     }
    #   }
    #   """

    #   assert_gql_error_data conn, query, [%{
    #     "field" => "permission_id",
    #     "message" => "Selected records are not part of the same group",
    #     "short_message" => "not_part_of_same_group"
    #   }]
    # end

    # @tag :token_login
    # test "it allows group owner to transfer ownership to another group member", %{conn: conn, user: user} do
    #   group = Fixture.group(%{name: "test-group"}, user)
    #   newOwner = Fixture.user
    #   member = Fixture.member(newOwner, group)

    #   query = """
    #   mutation {
    #     transfer_ownership(member_id: #{member.id}) {
    #       user { email }
    #       group {
    #         name
    #         owner {
    #           user { email }
    #         }
    #       }
    #     }
    #   }
    #   """

    #   assert_gql_data conn, query,
    #     %{
    #       "transfer_ownership" => %{
    #         "user" => %{"email" => newOwner.email},
    #         "group" => %{
    #           "name" => group.name,
    #           "owner" => %{
    #             "user" => %{"email" => newOwner.email}
    #           }
    #         }
    #       }
    #     }
    # end

    # @tag :token_login
    # test "it allows only group owners to transfer ownership to another group member", %{conn: conn, user: user} do
    #   owner = Fixture.user
    #   group = Fixture.group(%{name: "test-group"}, owner)
    #   member = Fixture.member(user, group)

    #   query = """
    #   mutation {
    #     transfer_ownership(member_id: #{member.id}) {
    #       user { email }
    #       group {
    #         name
    #         owner {
    #           user { email }
    #         }
    #       }
    #     }
    #   }
    #   """

    #   assert_gql_error_data conn, query, [%{
    #     "field" => "member_id",
    #     "message" => "Only group owner can transfer group ownership to another member",
    #     "short_message" => "only_owner_can_transfer_ownership"
    #   }]
    # end

    @tag :pending
    test "it doesn't allow members to modify group if they don't have the right permission" do
    end

    @tag :pending
    test "it allows members to modify a group when another member gives them permission via role" do
    end
  end
end
