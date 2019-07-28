defmodule TodoBackend.Category.Repository.TodoCategoryTest do
  use TodoBackend.DataCase

  alias TodoBackend.Category.Repository.TodoCategoryRepo

  describe "todo_categories" do
    alias TodoBackend.Category.Model.TodoCategory

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def todo_category_fixture(attrs \\ %{}) do
      {:ok, todo_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TodoCategoryRepo.create_todo_category()

      todo_category
    end

    test "list_todo_categories/0 returns all todo_categories" do
      todo_category = todo_category_fixture()
      assert TodoCategoryRepo.list_todo_categories() == [todo_category]
    end

    test "get_todo_category!/1 returns the todo_category with given id" do
      todo_category = todo_category_fixture()
      assert TodoCategoryRepo.get_todo_category!(todo_category.id) == todo_category
    end

    test "create_todo_category/1 with valid data creates a todo_category" do
      assert {:ok, %TodoCategory{} = todo_category} = TodoCategoryRepo.create_todo_category(@valid_attrs)
    end

    test "create_todo_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TodoCategoryRepo.create_todo_category(@invalid_attrs)
    end

    test "update_todo_category/2 with valid data updates the todo_category" do
      todo_category = todo_category_fixture()

      assert {:ok, %TodoCategory{} = todo_category} =
      TodoCategoryRepo.update_todo_category(todo_category, @update_attrs)
    end

    test "update_todo_category/2 with invalid data returns error changeset" do
      todo_category = todo_category_fixture()

      assert {:error, %Ecto.Changeset{}} =
      TodoCategoryRepo.update_todo_category(todo_category, @invalid_attrs)

      assert todo_category == TodoCategoryRepo.get_todo_category!(todo_category.id)
    end

    test "delete_todo_category/1 deletes the todo_category" do
      todo_category = todo_category_fixture()
      assert {:ok, %TodoCategory{}} = TodoCategoryRepo.delete_todo_category(todo_category)
      assert_raise Ecto.NoResultsError, fn -> TodoCategoryRepo.get_todo_category!(todo_category.id) end
    end

    test "change_todo_category/1 returns a todo_category changeset" do
      todo_category = todo_category_fixture()
      assert %Ecto.Changeset{} = TodoCategoryRepo.change_todo_category(todo_category)
    end
  end
end
