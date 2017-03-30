defmodule CPAP.Web.Router do
  use CPAP.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CPAP.Web.Auth, repo: CPAP.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CPAP.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", CPAP.Web do
    pipe_through [:browser, :authenticate_user]

    resources "/products", ProductController
    resources "/orders", OrderController
    post "/orders/:id", OrderController, :update
    resources "/items", ItemController

  end

  # Other scopes may use custom stacks.
  # scope "/api", CPAP do
  #   pipe_through :api
  # end
end
