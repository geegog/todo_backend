defmodule TodoBackendWeb.Router do
  use TodoBackendWeb, :router

  alias TodoBackend.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", TodoBackendWeb do
    pipe_through :api
    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in

    put "/category/:id/update", CategoryController, :update
    delete "/category/:id/delete", CategoryController, :delete
    post "/category/create", CategoryController, :create
    get "/category/all", CategoryController, :index
    get "/category/:id/view", CategoryController, :show
  end

  scope "/api/v1", TodoBackendWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my_user", UserController, :show
    get "/user/all", UserController, :index
    put "/user/:id/update", UserController, :update
    delete "/user/:id/delete", UserController, :delete

    put "/todo/:id/update", TodoController, :update
    delete "/todo/:id/delete", TodoController, :delete
    post "/todo/user/:user_id/category/:category_id/create", TodoController, :create
    get "/todo/:id/view", TodoController, :show
    get "/todo/all", TodoController, :index

    put "/comment/:id/update", CommentController, :update
    delete "/comment/:id/delete", CommentController, :delete
    post "/comment/user/:user_id/todo/:todo_id/create", CommentController, :create
    get "/comment/all", CommentController, :index
    get "/comment/:id/view", CommentController, :show

    put "/todo_category/:id/update", TodoCategoryController, :update
    delete "/todo_category/:id/delete", TodoCategoryController, :delete
    post "/todo_category/category/:category_id/todo/:todo_id/create", TodoCategoryController, :create
    get "/todo_category/all", TodoCategoryController, :index
    get "/todo_category/:id/view", TodoCategoryController, :show
  end
end
