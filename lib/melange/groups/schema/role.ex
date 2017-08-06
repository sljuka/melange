defmodule Melange.Groups.Role do
  alias Melange.Groups.Group
  alias Melange.Groups.MemberRole
  import Ecto.Changeset
  use Ecto.Schema

  schema "roles" do
    belongs_to :group, Group
    field    :name,         :string
    field    :description,  :string
    has_many :member_roles, MemberRole
    has_many :members, through: [:member_roles, :member]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_id, :name, :description])
    |> validate_required([:group_id, :name])
    |> unique_constraint(:name, name: :roles_group_id_name_index, message: "has_been_taken")
  end
end
