defmodule TodoBackend.Task.ModelTest do
  use TodoBackend.DataCase

  alias TodoBackend.Task.Repository.TodoRepo
  alias TodoBackend.User.Repository.UserRepo

  describe "todos" do
    alias TodoBackend.Task.Model.Todo

    @valid_attrs %{deadline: ~N[2010-04-17 14:00:00], description: "some description", title: "some title"}
    @update_attrs %{deadline: ~N[2011-05-18 15:01:01], description: "some updated description", title: "some updated title"}
    @invalid_attrs %{deadline: nil, description: nil, title: nil}
    @valid_user_attrs %{email: "some@email.com", name: "some name", phone: "123456789", password: "password", password_confirmation: "password"}

    def todo_fixture(attrs \\ %{}) do
      user = user_fixture()
      {:ok, todo} =
        attrs
        |> Enum.into(@valid_attrs |> Map.put(:user_id, user.id))
        |> TodoRepo.create_todo()

      todo
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> UserRepo.create_user()

      user
    end

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert length(TodoRepo.list_todos()) == length([todo])
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture() |> TodoRepo.preload
      assert TodoRepo.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      user = user_fixture()
      assert {:ok, %Todo{} = todo} = TodoRepo.create_todo(@valid_attrs |> Map.put(:user_id, user.id))
      assert todo.deadline == ~N[2010-04-17 14:00:00]
      assert todo.description == "some description"
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TodoRepo.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{} = todo} = TodoRepo.update_todo(todo, @update_attrs)
      assert todo.deadline == ~N[2011-05-18 15:01:01]
      assert todo.description == "some updated description"
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture() |> TodoRepo.preload
      assert {:error, %Ecto.Changeset{}} = TodoRepo.update_todo(todo, @invalid_attrs)
      assert todo == TodoRepo.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = TodoRepo.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> TodoRepo.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = TodoRepo.change_todo(todo)
    end
  end
end
