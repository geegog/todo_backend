defmodule TodoBackendWeb.Router do
  use TodoBackendWeb, :router

  alias TodoBackend.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug TodoBackend.Guardian.AuthPipeline
  end

  scope "/api/v1", TodoBackendWeb do
    pipe_through :api
    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
  end

  scope "/api/v1", TodoBackendWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my_user", UserController, :show
  end
end
