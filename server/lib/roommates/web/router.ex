defmodule Roommates.Web.Router do
  use Roommates.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Roommates.Auth, repo: Roommates.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Roommates.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/testlog", PageController, :test_login
    delete "/logout", AuthController, :logout

    resources "/rooms", RoomController
    get "/rooms/:id/add_roommate", RoomController, :new_roommate
    post "/rooms/:id/add_roommate", RoomController, :add_roommate
    delete "/rooms/:id/add_roommate/:user_id", RoomController, :remove_roommate
  end

  scope "/auth", Roommates.Web do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Roommates do
  #   pipe_through :api
  # end
end
