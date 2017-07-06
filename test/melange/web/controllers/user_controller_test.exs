defmodule Melange.Web.UserControllerTest do
  use Melange.Web.ConnCase
  alias Melange.Fixture

  @create_attrs %{first_name: "some_first_name", last_name: "some_last_name", email: "some@mail.com", password: "test"}
  @update_attrs Map.merge(@create_attrs, %{first_name: "updated_first_name", last_name: "updated_last_name", email: "new@mail.com"})
  @invalid_attrs %{first_name: nil, last_name: nil, email: nil}

  @tag login_as: "pera@mail.com"
  test "lists all users on index", %{conn: conn, user: _user} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Users"
  end

  @tag login_as: "pera@mail.com"
  test "renders form for new users", %{conn: conn, user: _user} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New User"
  end

  @tag login_as: "pera@mail.com"
  test "creates user and redirects to show when data is valid", %{conn: conn, user: _user} do
    conn = post conn, user_path(conn, :create), user: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == user_path(conn, :show, id)

    conn = get conn, user_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show User"
  end

  @tag login_as: "pera@mail.com"
  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New User"
  end

  @tag login_as: "pera@mail.com"
  test "renders form for editing chosen user", %{conn: conn} do
    user = Fixture.user
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit User"
  end

  @tag login_as: "pera@mail.com"
  test "updates chosen user and redirects when data is valid", %{conn: conn} do
    user = Fixture.user
    conn = put conn, user_path(conn, :update, user), user: @update_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)

    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "updated_first_name"
  end

  @tag login_as: "pera@mail.com"
  test "does not update chosen user and renders errors when data is invalid", %{conn: conn, user: _user} do
    user = Fixture.user
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit User"
  end

  @tag login_as: "pera@mail.com"
  test "deletes chosen user", %{conn: conn, user: _user} do
    user = Fixture.user
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == user_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, user)
    end
  end
end
