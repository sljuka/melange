defmodule Melange.GraphQL.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        IO.inspect("blaa")
        conn
      user ->
        IO.inspect("blaa2")
        put_private(conn, :absinthe, %{context: %{current_user: user}})
    end
  end
end
