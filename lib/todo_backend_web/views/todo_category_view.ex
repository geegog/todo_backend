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
    %{id: todo_category.id}
  end
end
