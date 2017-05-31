defmodule Roommates.Rooms do
  @moduledoc """
  The boundary for the Rooms system.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  import Ecto

  alias Roommates.Repo

  alias Roommates.Rooms.Room
  alias Roommates.Rooms.Roommate

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room) |> Repo.preload(:admin)
  end

  def list_users_rooms(user) do
    Repo.all(assoc(user, :admin_rooms)) |> Repo.preload(:admin)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id) |> Repo.preload(:admin)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}, admin) do
    %Room{}
    |> Room.changeset(attrs)
    |> put_assoc(:admin, admin)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def get_roommate!(room_id, user_id) do
    Roommates.Rooms.Roommate
    |> Ecto.Query.where(room_id: ^room_id)
    |> Ecto.Query.where(user_id: ^user_id)
    |> Repo.one!
  end

  def add_roommate(attrs \\ %{}, room) do
    %Roommate{room_id: room.id}
    |> Roommate.changeset(attrs)
    |> Repo.insert()
  end

  def change_roommate(%Roommate{} = roommate) do
     Roommate.changeset(roommate, %{})
  end

  def remove_roommate(room_id, user_id) do
    Roommates.Rooms.Roommate
    |> Ecto.Query.where(room_id: ^room_id)
    |> Ecto.Query.where(user_id: ^user_id)
    |> Repo.delete_all()
  end
end
