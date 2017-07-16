defmodule Melange.Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import Melange.Web.Router.Helpers
      import Melange.GraphqlTestHelper
      alias Melange.Fixture
      alias Melange.Users

      # The default endpoint for testing
      @endpoint Melange.Web.Endpoint

      def guardian_login(user, token \\ :token, opts \\ []) do
        build_conn()
        |> get("/")
        |> Map.update!(:state, fn (_) -> :set end)
        |> Guardian.Plug.sign_in(user, token, opts)
        |> send_resp(200, "Flush the session")
        |> recycle
      end

      setup config do
        cond do
          email = config[:login_as] ->
            user = Fixture.user(%{email: email})
            conn = guardian_login(user)

            {:ok, %{conn: conn, user: user}}
          email = config[:token_login_as] ->
            user = Fixture.user(%{email: email})
            {:ok, token} = Users.create_token(email, "test1234")

            conn =
              build_conn()
              |> put_req_header("authorization", "Bearer #{token}")

            {:ok, %{conn: conn, user: user}}
          true ->
            {:ok, %{conn: build_conn()}}
        end
      end
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Melange.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Melange.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
