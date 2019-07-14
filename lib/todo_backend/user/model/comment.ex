defmodule TodoBackend.User.Model.Comment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "comments" do
    field :text, :string
    field :todo_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
