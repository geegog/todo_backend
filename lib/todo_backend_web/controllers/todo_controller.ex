defmodule TodoBackendWeb.TodoController do
  use TodoBackendWeb, :controller

  alias TodoBackend.Task.Repository.TodoRepo
  alias TodoBackend.User.Repository.UserRepo
  alias TodoBackend.Task.Model.Todo

  action_fallback TodoBackendWeb.FallbackController

  def index(conn, _params) do
    todos = TodoRepo.list_todos()
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"id" => id, "todo" => todo_params}) do
    user = UserRepo.get_user!(id)

    with {:ok, %Todo{} = todo} <- TodoRepo.create_todo(Map.put(todo_params, "user_id", id)) do
      conn
      |> put_status(:created)
      |> render("todo.json", todo: TodoRepo.preload(todo))
    end
  end

  def show(conn, %{"id" => id}) do
    todo = TodoRepo.get_todo!(id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = TodoRepo.get_todo!(id)

    with {:ok, %Todo{} = todo} <- TodoRepo.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = TodoRepo.get_todo!(id)

    with {:ok, %Todo{}} <- TodoRepo.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
