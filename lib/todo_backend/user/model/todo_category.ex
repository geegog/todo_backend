defmodule TodoBackend.User.Model.TodoCategory do
  use Ecto.Schema
  import Ecto.Changeset


  schema "todo_categories" do
    field :todo_id, :id
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo_category, attrs) do
    todo_category
    |> cast(attrs, [])
    |> validate_required([])
  end
end
