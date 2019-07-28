defmodule TodoBackend.User.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :phone])
    |> validate_required([:email, :name, :phone])
    |> unique_constraint(:email)
  end
end
