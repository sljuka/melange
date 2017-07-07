defmodule Melange.Web.ContextAdapter do
  def adapt(conn) do
    Map.take(conn.assigns, [:current_user])
  end
end
