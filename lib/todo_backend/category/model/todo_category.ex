defmodule TodoBackend.Category.Model.TodoCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_categories" do
    belongs_to :todo, TodoBackend.Task.Model.Todo
    belongs_to :category, TodoBackend.Category.Model.Category

    timestamps()
  end

  @doc false
  def changeset(todo_category, attrs) do
    todo_category
    |> cast(attrs, [:todo_id, :category_id])
    |> validate_required([:todo_id, :category_id])
  end
end
