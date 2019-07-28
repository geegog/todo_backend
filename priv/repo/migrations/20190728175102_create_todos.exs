defmodule TodoBackend.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :deadline, :naive_datetime
      add :description, :string
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:todos, [:user_id])
  end
end
