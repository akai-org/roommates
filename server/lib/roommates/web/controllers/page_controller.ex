defmodule Roommates.Web.PageController do
  use Roommates.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test_login(conn, _params) do
    user = Repo.get(Roommates.Auth.User, 8)
    conn
    |> Roommates.Auth.logout()
    |> Roommates.Auth.login(user)
    |> redirect(to: page_path(conn, :index))
  end
end
