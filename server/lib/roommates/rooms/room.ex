defmodule Roommates.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Roommates.Rooms.Room


  schema "rooms_rooms" do
    field :name, :string
    belongs_to :admin, Roommates.Auth.User, foreign_key: :admin_id
    many_to_many :roommates, Roommates.Auth.User, join_through: Roommates.Rooms.Roommate

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
