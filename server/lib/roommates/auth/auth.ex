defmodule Roommates.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import Ecto.Changeset

  alias Roommates.Auth.UserSocial
  alias Roommates.Auth.User
  alias Roommates.Repo

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Repo.get(User, user_id)
    assign(conn, :current_user, user)
  end

  def get_user_social(auth) do
    Repo.get_by(UserSocial, [provider: Atom.to_string(auth.provider),
      provider_uid: auth.uid])
  end

  def create_user_social(auth, user) do
    UserSocial.changeset(%UserSocial{}, auth)
    |> put_assoc(:user, user)
    |> Repo.insert()
  end

  def get_user(%UserSocial{} = user_social) do
    user_social
    |> Ecto.assoc(:user)
    |> Repo.one()
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def login_by_ueberauth(conn, auth) do
    case get_user_social(auth) do
        %UserSocial{} = user_social ->
          user = get_user(user_social)
          {:found, user, login(conn, user)}
        nil ->
          {:notfound}
      end
  end

  def create_user_by_ueberauth(conn, auth) do
    # check if user with auth.info.email exists
    # if yes, use it otherwise create it
    user = if auth.info.email, do: get_user_by_email(auth.info.email)

    # create user
    unless user do
      user = case create_user(auth) do
        {:ok, user} ->
          conn |> login(user)
          user
        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Failed to authenticate.")
          |> redirect(to: "/")
          |> halt()
      end
    end

    create_user_social(auth, user)
    conn
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

  def current_user(conn) do
    conn.assigns.current_user
  end

  def is_logged(%Plug.Conn{assigns: %{current_user: user}}, user), do: {:ok}
  def is_logged(_conn, _user), do: {:wrong_user}
end
