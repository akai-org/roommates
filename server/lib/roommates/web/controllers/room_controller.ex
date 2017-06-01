defmodule Roommates.Web.RoomController do
  use Roommates.Web, :controller
  alias Plug.Conn
  alias Roommates.Rooms

  plug Roommates.Auth.RequireLogin
  # TODO: optimize sql queries
  plug Roommates.Rooms.RequireAdmin when not action in [:index, :new, :create, :show]

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    users_rooms = Roommates.Auth.current_user(conn) |> Rooms.list_users_rooms()
    render(conn, "index.html", users_rooms: users_rooms, rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Rooms.change_room(%Roommates.Rooms.Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case Rooms.create_room(room_params, Roommates.Auth.current_user(conn)) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: room_path(conn, :show, room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Rooms.get_room!(id) |> Repo.preload(:roommates)
    render(conn, "show.html", room: room)
  end

  def edit(%Conn{assigns: %{room: room}} = conn, %{"id" => id}) do
    changeset = Rooms.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(%Conn{assigns: %{room: room}} = conn, %{"id" => id, "room" => room_params}) do
    case Rooms.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: room_path(conn, :show, room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(%Conn{assigns: %{room: room}} = conn, %{"id" => id}) do
    {:ok, _room} = Rooms.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: room_path(conn, :index))
  end

  def new_roommate(%Conn{assigns: %{room: room}} = conn, %{"id" => id}) do
    changeset = Rooms.change_roommate(%Roommates.Rooms.Roommate{})

    render(conn, "new_roommate.html", room: room, changeset: changeset)
  end

  def add_roommate(%Conn{assigns: %{room: room}} = conn, %{"id" => id, "roommate" => roommate_params}) do
    case Rooms.add_roommate(roommate_params, room) do
      {:ok, _roommate} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: room_path(conn, :show, room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new_roommate.html", room: room, changeset: changeset)
    end
  end

  def remove_roommate(%Conn{assigns: %{room: room}} = conn, %{"id" => id, "user_id" => user_id}) do
    {1, _roommate} = Rooms.remove_roommate(id, user_id)
    conn
    |> put_flash(:info, "Roommate removed successfully.")
    |> redirect(to: room_path(conn, :show, room))
  end
end
