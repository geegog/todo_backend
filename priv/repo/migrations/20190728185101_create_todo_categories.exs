defmodule TodoBackend.Repo.Migrations.CreateTodoCategories do
  use Ecto.Migration

  def change do
    create table(:todo_categories) do
      add :todo_id, references(:todos, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:todo_categories, [:todo_id])
    create index(:todo_categories, [:category_id])
  end
end
