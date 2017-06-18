defmodule Melange.Web.UserController do
  use Melange.Web, :controller
  alias Melange.Accounts

  plug Guardian.Plug.EnsureAuthenticated, handler: Melange.Web.DefaultAuthErrorHandler
  plug :scrub_params, "user" when action in [:create]

  def index(conn, _params) do
    {:ok, users} = Accounts.list_users
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.registration_changeset(%Accounts.User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.update_changeset(user, %{})
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn =
      if conn.assigns.current_user == user do
        Guardian.Plug.sign_out(conn)
      else
        conn
      end

    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
