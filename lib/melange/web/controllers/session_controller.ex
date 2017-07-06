defmodule Melange.Web.SessionController do
  use Melange.Web, :controller
  alias Melange.Users

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "login.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Users.find_and_checkpw(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> put_status(401)
        |> render("login.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end
end
