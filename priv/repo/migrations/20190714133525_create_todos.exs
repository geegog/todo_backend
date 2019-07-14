defmodule TodoBackend.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :description, :string
      add :deadline, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:todos, [:user_id])
  end
end
