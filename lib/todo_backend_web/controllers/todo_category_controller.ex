defmodule TodoBackendWeb.TodoCategoryController do
  use TodoBackendWeb, :controller

  alias TodoBackend.Category.Repository.TodoCategoryRepo
  alias TodoBackend.Category.Model.TodoCategory

  action_fallback TodoBackendWeb.FallbackController

  def index(conn, _params) do
    todo_categories = TodoCategoryRepo.list_todo_categories()
    render(conn, "index.json", todo_categories: todo_categories)
  end

  def create(conn, %{"todo_category" => todo_category_params}) do
    with {:ok, %TodoCategory{} = todo_category} <- TodoCategoryRepo.create_todo_category(todo_category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.todo_category_path(conn, :show, todo_category))
      |> render("show.json", todo_category: todo_category)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_category = TodoCategoryRepo.get_todo_category!(id)
    render(conn, "show.json", todo_category: todo_category)
  end

  def update(conn, %{"id" => id, "todo_category" => todo_category_params}) do
    todo_category = TodoCategoryRepo.get_todo_category!(id)

    with {:ok, %TodoCategory{} = todo_category} <- TodoCategoryRepo.update_todo_category(todo_category, todo_category_params) do
      render(conn, "show.json", todo_category: todo_category)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_category = TodoCategoryRepo.get_todo_category!(id)

    with {:ok, %TodoCategory{}} <- TodoCategoryRepo.delete_todo_category(todo_category) do
      send_resp(conn, :no_content, "")
    end
  end
end
