defmodule Roommates.Auth.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: "/")
      |> halt()
    end
  end
end

defmodule Roommates.Auth.RequireGuest do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if !conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be guest to access that page")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
