defmodule TodoBackend.Task.Repository.CommentTest do
  use TodoBackend.DataCase

  alias TodoBackend.Task.Repository.CommentRepo

  describe "comments" do
    alias TodoBackend.Task.Model.Comment
    alias TodoBackend.Task.Repository.TodoRepo
    alias TodoBackend.User.Repository.UserRepo

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}
    @valid_user_attrs %{email: "some@email.com", name: "some name", phone: "123456789", password: "password", password_confirmation: "password"}
    @valid_todo_attrs %{deadline: ~N[2010-04-17 14:00:00], description: "some description", title: "some title"}

    def comment_fixture(attrs \\ %{}) do
      todo = todo_fixture()
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs |> Map.put(:user_id, todo.user.id) |> Map.put(:todo_id, todo.id))
        |> CommentRepo.create_comment()

      comment
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

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert length(CommentRepo.list_comments()) == length([comment])
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture() |> CommentRepo.preload
      assert CommentRepo.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      todo = todo_fixture()
      assert {:ok, %Comment{} = comment} = CommentRepo.create_comment(@valid_attrs |> Map.put(:user_id, todo.user.id) |> Map.put(:todo_id, todo.id))
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommentRepo.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = CommentRepo.update_comment(comment, @update_attrs)
      assert comment.text == "some updated text"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture() |> CommentRepo.preload
      assert {:error, %Ecto.Changeset{}} = CommentRepo.update_comment(comment, @invalid_attrs)
      assert comment == CommentRepo.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = CommentRepo.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> CommentRepo.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = CommentRepo.change_comment(comment)
    end
  end
end
