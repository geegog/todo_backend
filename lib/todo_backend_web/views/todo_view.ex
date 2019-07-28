defmodule TodoBackendWeb.TodoView do
  use TodoBackendWeb, :view
  alias TodoBackendWeb.TodoView

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      deadline: todo.deadline,
      description: todo.description,
      title: todo.title}
  end
end
