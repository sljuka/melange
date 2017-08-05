defmodule Melange.Groups.Permission do
  alias Melange.Groups.Group
  import Ecto.Changeset
  use Ecto.Schema

  schema "permissions" do
    belongs_to :group,       Melange.Groups.Group
    field      :name,        :string
    field      :description, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_id, :name, :description])
    |> validate_required([:group_id, :name])
    |> unique_constraint(:name, name: :permissions_group_id_name_index, message: "has already been taken")
  end
end
