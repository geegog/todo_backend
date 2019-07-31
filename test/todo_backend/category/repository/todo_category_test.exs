defmodule TodoBackend.Category.Repository.TodoCategoryTest do
  use TodoBackend.DataCase

  alias TodoBackend.Category.Repository.TodoCategoryRepo
  alias TodoBackend.Category.Repository.CategoryRepo
  alias TodoBackend.Task.Repository.TodoRepo
  alias TodoBackend.User.Repository.UserRepo

  describe "todo_categories" do
    alias TodoBackend.Category.Model.TodoCategory

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}
    @valid_user_attrs %{email: "some@email.com", name: "some name", phone: "123456789", password: "password", password_confirmation: "password"}
    @valid_todo_attrs %{deadline: ~N[2010-04-17 14:00:00], description: "some description", title: "some title"}
    @valid_category_attrs %{name: "some name"}

    def todo_category_fixture(attrs \\ %{}) do
      category = category_fixture()
      todo = todo_fixture()

      {:ok, todo_category} =
        attrs
        |> Enum.into(@valid_attrs |> Map.put(:todo_id, todo.id) |> Map.put(:category_id, category.id))
        |> TodoCategoryRepo.create_todo_category()

      todo_category
    end

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_category_attrs)
        |> CategoryRepo.create_category()

      category
    end

    def todo_fixture(attrs \\ %{}) do
      user = user_fixture()
      {:ok, todo} =
        attrs
        |> Enum.into(@valid_todo_attrs |> Map.put(:user_id, user.id))
        |> TodoRepo.create_todo()

      todo |> TodoRepo.preload
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> UserRepo.create_user()

      user
    end

    test "list_todo_categories/0 returns all todo_categories" do
      todo_category = todo_category_fixture() |> TodoCategoryRepo.preload
      assert TodoCategoryRepo.list_todo_categories() == [todo_category]
    end

    test "get_todo_category!/1 returns the todo_category with given id" do
      todo_category = todo_category_fixture() |> TodoCategoryRepo.preload
      assert TodoCategoryRepo.get_todo_category!(todo_category.id) == todo_category
    end

    test "create_todo_category/1 with valid data creates a todo_category" do
      category = category_fixture()
      todo = todo_fixture()
      assert {:ok, %TodoCategory{} = todo_category} = TodoCategoryRepo.create_todo_category(@valid_attrs |> Map.put(:todo_id, todo.id) |> Map.put(:category_id, category.id))
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
      todo_category = todo_category_fixture() |> TodoCategoryRepo.preload

      assert {:error, %Ecto.Changeset{}} =
      TodoCategoryRepo.update_todo_category(todo_category |> Map.drop([:category_id]), @invalid_attrs)

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
