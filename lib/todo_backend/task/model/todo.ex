defmodule TodoBackend.Task.Model.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :deadline, :naive_datetime
    field :description, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:deadline, :description, :title])
    |> validate_required([:deadline, :description, :title])
  end
end
