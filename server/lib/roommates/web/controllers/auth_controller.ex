defmodule Roommates.Web.AuthController do
  use Roommates.Web, :controller

  plug Ueberauth
  plug Roommates.Auth.RequireGuest when not action in [:logout]
  plug Roommates.Auth.RequireLogin when action in [:logout]

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Roommates.Auth.login_by_ueberauth(conn, auth) do
      # case when user is successfully logged in
      {:found, user, conn} ->
        conn
        |> put_flash(:info, "Successfully authenticated as #{user.name}.")
        |> redirect(to: "/")
      # case when it is first use of provider
      {:notfound} ->
        conn
        |> Roommates.Auth.create_user_by_ueberauth(auth)
        |> put_flash(:info, "Registered.")
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> Roommates.Auth.logout()
    |> put_flash(:info, "Logged out.")
    |> redirect(to: "/")
  end
end
