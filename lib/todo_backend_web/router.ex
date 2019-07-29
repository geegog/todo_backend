defmodule TodoBackendWeb.Router do
  use TodoBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TodoBackendWeb do
    pipe_through :api
    resources "/users", UserController, only: [:create, :show]
  end
end
