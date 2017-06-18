defmodule Melange.Web.DefaultAuthErrorHandler do
  use Melange.Web, :controller

  def unauthenticated(conn, _params) do
    conn
      |> put_status(301)
      |> put_flash(:error, "Authentication required")
      |> redirect(to: "/")
  end
end
