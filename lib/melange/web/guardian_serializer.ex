defmodule Melange.Web.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Melange.Users

  def for_token(user = %Users.User{}), do: { :ok, "User:#{user.id}" }

  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, Users.get_user(id) }

  def from_token(_), do: { :error, "Unknown resource type" }
end
