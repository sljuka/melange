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

  pipeline :graphql do
    plug Melange.Logger
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Melange.GraphQL.Context
  end

  scope "/", Melange.Web do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/api" do
    pipe_through [:graphql]

    forward "/", Absinthe.Plug, schema: Melange.GraphQL.Schema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Melange.GraphQL.Schema
end
