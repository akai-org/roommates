defmodule Roommates.Auth.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{current_user: %Roommates.Auth.User{}}} = conn, _opts), do: conn

  def call(conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: "/")
    |> halt()
  end
end

defmodule Roommates.Auth.RequireGuest do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts), do: conn

  def call(conn, _opts) do
    conn
    |> put_flash(:error, "You must be guest to access that page")
    |> redirect(to: "/")
    |> halt()
  end
end
