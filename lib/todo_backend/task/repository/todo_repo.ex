defmodule TodoBackend.Task.Repository.TodoRepo do
  @moduledoc """
  The Task context.
  """

  import Ecto.Query, warn: false
  alias TodoBackend.Repo

  alias TodoBackend.Task.Model.Todo
  alias TodoBackend.Category.Model.TodoCategory
  alias Ecto.Multi

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos(params) do
    query = from(t in Todo, preload: [:user], order_by: [desc: t.inserted_at, desc: t.id], select: t)

    Repo.paginate(query, params)
    # cond do
    #   params["after"] !== nil -> Repo.paginate(query, after: params["after"], cursor_fields: [:inserted_at, :id], limit: 10)
    #   params["before"] !== nil -> Repo.paginate(query, before: params["before"], cursor_fields: [:inserted_at, :id], limit: 10)
    #   true -> Repo.paginate(query, cursor_fields: [:inserted_at, :id], limit: 10)
    # end
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id) |> Repo.preload(:user)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  def create_todo_category(attrs \\ %{}, todoCategoryAttrs) do
    Multi.new
    |> Multi.insert(:todo, Todo.changeset(%Todo{}, attrs))
    |> Multi.run(:todoCategory, fn _repo, %{todo: todo} ->
      Repo.insert(TodoCategory.changeset(%TodoCategory{}, Map.put(todoCategoryAttrs, "todo_id", todo.id)))
    end)
    |> Repo.transaction()
  end

  def preload(%Todo{} = todo) do
    todo
    |> Repo.preload(:user)
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{source: %Todo{}}

  """
  def change_todo(%Todo{} = todo) do
    Todo.changeset(todo, %{})
  end
end
