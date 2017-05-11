defmodule Roommates.Router do
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

  scope "/", Roommates do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    delete "/logout", AuthController, :logout
  end

  scope "/auth", Roommates do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Roommates do
  #   pipe_through :api
  # end
end
