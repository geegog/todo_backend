defmodule TodoBackend.Task.Model.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :text, :string
    belongs_to :user, TodoBackend.User.Model.User
    belongs_to :todo, TodoBackend.Task.Model.Todo

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
