defmodule TodoBackend.User.Model.User do
  use Ecto.Schema
  import Ecto.Changeset
  # import Argon2, only: [hash_pwd_salt: 1]

  schema "users" do
    field :email, :string
    field :name, :string
    field :phone, :string
    field :password_hash, :string
    # Virtual fields:
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :phone])
    |> validate_required([:email, :name, :phone])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
