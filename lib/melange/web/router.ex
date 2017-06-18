defmodule Melange.Web.Router do
  use Melange.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Melange.Web.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Melange.Web do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Melange.Web do
  #   pipe_through :api
  # end
end
