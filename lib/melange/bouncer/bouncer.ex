defmodule Melange.Bouncer do
  def check_authentication(context) do
    case context do
      %{current_user: nil} -> {:error, :not_authenticated}
      %{current_user: _current_user} -> :ok
      _ -> {:error, :not_authenticated}
    end
  end

  def check_authentication!(context) do
    case context do
      %{current_user: nil} -> {:error, :not_authenticated}
      %{current_user: _current_user} -> :ok
      _ -> {:error, :not_authenticated}
    end
  end

  def check_authorization(_group_id, _context, _rule) do
    :ok
  end
end
