defmodule Melange.Bouncer do
  def check_authentication(context) do
    case context do
      %{current_user: nil} -> {:error, "User is not authenticated"}
      %{current_user: _current_user} -> :ok
      _ -> {:error, "User is not authenticated"}
    end
  end

  def check_authentication!(context) do
    case context do
      %{current_user: nil} -> {:error, "User is not authenticated"}
      %{current_user: _current_user} -> :ok
      _ -> {:error, "User is not authenticated"}
    end
  end

  def check_authorization(_group_id, _context, _rule) do
    :ok
  end
end
