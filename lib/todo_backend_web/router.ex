defmodule TodoBackendWeb.Router do
  use TodoBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TodoBackendWeb do
    pipe_through :api
    post "/sign_up", UserController, :create
  end
end
