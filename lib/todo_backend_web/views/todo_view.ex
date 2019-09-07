defmodule TodoBackendWeb.TodoView do
  use TodoBackendWeb, :view
  alias TodoBackendWeb.TodoView

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos.entries, TodoView, "todo.json"),
    metadata: %{page_number: todos.page_number,
    page_size: todos.page_size,
    total_pages: todos.total_pages,
    total_entries: todos.total_entries}}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      deadline: todo.deadline,
      description: todo.description,
      title: todo.title,
      user: %{id: todo.user.id, email: todo.user.email, phone: todo.user.phone, name: todo.user.name}
    }
  end
end
