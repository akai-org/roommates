defmodule Roommates.Rooms.Roommate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Roommates.Rooms.Roommate

  @primary_key false
  schema "rooms_roommates" do
    belongs_to :user, Roommates.Auth.User
    belongs_to :room, Roommates.Rooms.Room
    timestamps
  end

  def changeset(%Roommate{} = roommate, attrs) do
    roommate
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id, name: :rooms_roommates_user_id_room_id_index,
      message: "is already your roommate")
  end
end
