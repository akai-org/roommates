defmodule Roommates.AuthController do
  use Roommates.Web, :controller
  plug Ueberauth
  alias Roommates.User
  alias Roommates.UserSocial

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Roommates.Auth.login_by_ueberauth(conn, auth, Repo) do
      # case when user is successfully logged in
      {:found, user, conn} ->
        conn
        |> put_flash(:info, "Successfully authenticated as #{user.name}.")
        |> redirect(to: "/")
      # case when it is first use of provider
      {:notfound} ->
        conn
        |> create_user_by_ueberauth(auth)
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

  defp create_user_by_ueberauth(conn, auth) do
    # check if user with auth.info.email exists
    # if yes, use it otherwise create it
    user = if auth.info.email, do: Repo.get_by(User, email: auth.info.email)

    # create user
    unless user do
      user_changeset = User.registration_changeset(%User{}, auth)
      user = case Repo.insert(user_changeset) do
        {:ok, user} ->
          conn |> Roommates.Auth.login(user)
          user
        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Failed to authenticate.")
          |> redirect(to: "/")
          |> halt()
      end
    end

    user_social_changeset = user
      |> build_assoc(:user_socials)
      |> UserSocial.changeset(auth)
    # if insert fails, nothing wrong happens
    # UserSocial will be created during next log in
    Repo.insert(user_social_changeset)
    conn
  end

end
