defmodule TodoBackend.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :todo_id, references(:todos, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:todo_id])
  end
end
