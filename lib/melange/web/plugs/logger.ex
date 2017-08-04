defmodule Melange.Logger do
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.inspect("shyiiit")
    conn
  end
end
