defmodule Roommates.Rooms.RequireAdmin do
  import Plug.Conn
  import Phoenix.Controller
  import Roommates.Web.Router.Helpers

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"id" => id}, assigns: %{current_user: current_user}} = conn, _opts) do
    room = Roommates.Rooms.get_room!(id)

    case room.admin do
      ^current_user ->
        assign(conn, :room, room)
      _ ->
        conn
        |> put_flash(:error, "You have no right manage this room")
        |> redirect(to: room_path(conn, :index))
    end
  end
end
