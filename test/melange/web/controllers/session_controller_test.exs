defmodule Melange.Web.SessionControllerTest do
  use Melange.Web.ConnCase
  alias Melange.Fixture

  test "renders login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Sign in"
  end

  test "renders error when bad creds are passed", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: %{email: "test@mail.com", password: "testpass"}
    assert html_response(conn, 401) =~ "Invalid email/password combination"
  end

  test "sets current_user after successive login", %{conn: conn} do
    user = Fixture.user
    conn = conn
      |> post(session_path(conn, :create), session: %{email: "user@mail.com", password: "test1234"})
      |> get("/")

    assert html_response(conn, 200) =~ "You’re now logged in!"
    assert conn.assigns.current_user == user
  end
end
