defmodule Roommates.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Roommates.UserSocial
  alias Roommates.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)
    assign(conn, :current_user, user)
  end

  def login_by_ueberauth(conn, auth, repo) do
    case repo.get_by(UserSocial, [provider: Atom.to_string(auth.provider),
      provider_uid: auth.uid]) do
        %UserSocial{} = user_social ->
          user = user_social
          |> Ecto.assoc(:user)
          |> repo.one()

          {:found, user, login(conn, user)}
        nil ->
          {:notfound}
      end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    delete_session(conn, :user_id)
  end
end

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
