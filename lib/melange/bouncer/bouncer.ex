defmodule Melange.Bouncer do
  def check_authentication(context) do
    case context do
      %{current_user: nil} -> {:error, "User not authenticated"}
      %{current_user: current_user} -> :ok
      _ -> {:error, "User not authenticated"}
    end
  end

  def check_authentication!(context) do
    case context do
      %{current_user: nil} -> {:error, "User not authenticated"}
      %{current_user: current_user} -> :ok
      _ -> {:error, "User not authenticated"}
    end
  end

  def check_authorization(group_id, context, rule) do
    :ok
  end
end
