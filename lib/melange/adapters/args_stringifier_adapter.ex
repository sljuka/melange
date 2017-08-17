defmodule Melange.Adapters.ArgsStringifierAdapter do
  def adapt(args) do
    args
    |> stringify_keys
  end

  def stringify_keys(nil), do: nil

  def stringify_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), stringify_keys(v)} end)
    |> Enum.into(%{})
  end

  def stringify_keys(not_a_map), do: not_a_map
end
