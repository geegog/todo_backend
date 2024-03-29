defmodule TodoBackend.Task.Model.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :deadline, :naive_datetime
    field :description, :string
    field :title, :string
    belongs_to :user, TodoBackend.User.Model.User

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:deadline, :description, :title, :user_id])
    |> validate_required([:deadline, :description, :title, :user_id])
  end
end
