defmodule Melange.ErrorMessages do
  def to_long_message(message) do
    str_message = to_string(message)

    case str_message do
      "has_been_taken" ->
        "Unique value has already been assigned to another record"

      "already_requested" ->
        "User already requested to join the group"

      "permission_already_assigned_to_role" ->
        "Permission has already been assigned to role"

      "user_already_invited" ->
        "User has already been invited to join the group"

      "can't be blank" ->
        "Value can't be blank"

      "already_member" ->
        "User can't join the group since he is already member of that group"

      "only_accept_own_invite" ->
        "User can accept only his own group invites"

      "not_part_of_same_group" ->
        "Selected records are not part of the same group"

      "can_not_remove_owner" ->
        "Owner can't be removed from group members"

      "invalid_creds" ->
        "Invalid email or password"

      "not_authenticated" ->
        "User is not authenticated"

      _ -> str_message
    end
  end

  def to_short_message(message) do
    case message do
      "can't be blank" -> "can_not_be_blank"

      _ -> message
    end
  end
end
