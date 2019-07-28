defmodule TodoBackend.Category.ModelTest do
  use TodoBackend.DataCase

  alias TodoBackend.Category.Model

  describe "categories" do
    alias TodoBackend.Category.Model.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Model.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Model.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Model.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Model.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_category(category, @invalid_attrs)
      assert category == Model.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Model.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Model.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Model.change_category(category)
    end
  end

  describe "todo_categories" do
    alias TodoBackend.Category.Model.TodoCategory

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def todo_category_fixture(attrs \\ %{}) do
      {:ok, todo_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_todo_category()

      todo_category
    end

    test "list_todo_categories/0 returns all todo_categories" do
      todo_category = todo_category_fixture()
      assert Model.list_todo_categories() == [todo_category]
    end

    test "get_todo_category!/1 returns the todo_category with given id" do
      todo_category = todo_category_fixture()
      assert Model.get_todo_category!(todo_category.id) == todo_category
    end

    test "create_todo_category/1 with valid data creates a todo_category" do
      assert {:ok, %TodoCategory{} = todo_category} = Model.create_todo_category(@valid_attrs)
    end

    test "create_todo_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_todo_category(@invalid_attrs)
    end

    test "update_todo_category/2 with valid data updates the todo_category" do
      todo_category = todo_category_fixture()
      assert {:ok, %TodoCategory{} = todo_category} = Model.update_todo_category(todo_category, @update_attrs)
    end

    test "update_todo_category/2 with invalid data returns error changeset" do
      todo_category = todo_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_todo_category(todo_category, @invalid_attrs)
      assert todo_category == Model.get_todo_category!(todo_category.id)
    end

    test "delete_todo_category/1 deletes the todo_category" do
      todo_category = todo_category_fixture()
      assert {:ok, %TodoCategory{}} = Model.delete_todo_category(todo_category)
      assert_raise Ecto.NoResultsError, fn -> Model.get_todo_category!(todo_category.id) end
    end

    test "change_todo_category/1 returns a todo_category changeset" do
      todo_category = todo_category_fixture()
      assert %Ecto.Changeset{} = Model.change_todo_category(todo_category)
    end
  end
end
