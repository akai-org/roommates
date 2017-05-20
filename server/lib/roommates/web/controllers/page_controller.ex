defmodule Roommates.Web.PageController do
  use Roommates.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
