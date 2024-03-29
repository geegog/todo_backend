defmodule TodoBackend.Category.Repository.TodoCategoryRepo do
  @moduledoc """
  The Category.Model context.
  """

  import Ecto.Query, warn: false
  alias TodoBackend.Repo

  alias TodoBackend.Category.Model.TodoCategory
  alias TodoBackend.Task.Model.Comment
  alias TodoBackend.Task.Model.Todo

  @doc """
  Returns the list of todo_categories.

  ## Examples

      iex> list_todo_categories()
      [%TodoCategory{}, ...]

  """
  def list_todo_categories(params) do
    query =
      from(tc in TodoCategory,
        left_join: t in Todo,
        on: t.id == tc.todo_id,
        left_join: c in Comment,
        on: c.todo_id == t.id,
        preload: [:todo, :category],
        order_by: [desc: tc.inserted_at, desc: tc.id],
        group_by: tc.id,
        select: %{todo_category: tc, comments_count: count(c.id)}
      )

    Repo.paginate(query, params)
  end

  @doc """
  Gets a single todo_category.

  Raises `Ecto.NoResultsError` if the Todo category does not exist.

  ## Examples

      iex> get_todo_category!(123)
      %TodoCategory{}

      iex> get_todo_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo_category!(id),
    do: Repo.get!(TodoCategory, id) |> Repo.preload(:todo) |> Repo.preload(:category)

  @doc """
  Creates a todo_category.

  ## Examples

      iex> create_todo_category(%{field: value})
      {:ok, %TodoCategory{}}

      iex> create_todo_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo_category(attrs \\ %{}) do
    %TodoCategory{}
    |> TodoCategory.changeset(attrs)
    |> Repo.insert()
  end

  def preload(%TodoCategory{} = todo_category) do
    todo_category
    |> Repo.preload(:todo)
    |> Repo.preload(:category)
  end

  @doc """
  Updates a todo_category.

  ## Examples

      iex> update_todo_category(todo_category, %{field: new_value})
      {:ok, %TodoCategory{}}

      iex> update_todo_category(todo_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo_category(%TodoCategory{} = todo_category, attrs) do
    todo_category
    |> TodoCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TodoCategory.

  ## Examples

      iex> delete_todo_category(todo_category)
      {:ok, %TodoCategory{}}

      iex> delete_todo_category(todo_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo_category(%TodoCategory{} = todo_category) do
    Repo.delete(todo_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo_category changes.

  ## Examples

      iex> change_todo_category(todo_category)
      %Ecto.Changeset{source: %TodoCategory{}}

  """
  def change_todo_category(%TodoCategory{} = todo_category) do
    TodoCategory.changeset(todo_category, %{})
  end
end
