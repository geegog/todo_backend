defmodule TodoBackendWeb.TodoCategoryView do
  use TodoBackendWeb, :view
  alias TodoBackendWeb.TodoCategoryView

  def render("index.json", %{todo_categories: todo_categories}) do
    %{data: render_many(todo_categories, TodoCategoryView, "todo_category.json")}
  end

  def render("show.json", %{todo_category: todo_category}) do
    %{data: render_one(todo_category, TodoCategoryView, "todo_category.json")}
  end

  def render("todo_category.json", %{todo_category: todo_category}) do
    %{
      id: todo_category.id,
      category: %{id: todo_category.category.id, name: todo_category.category.name},
      todo: %{
        id: todo_category.todo.id,
        deadline: todo_category.todo.deadline,
        description: todo_category.todo.description,
        title: todo_category.todo.title
      }
    }
  end
end
