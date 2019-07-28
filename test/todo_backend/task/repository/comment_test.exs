defmodule TodoBackend.Task.Repository.CommentTest do
  use TodoBackend.DataCase

  alias TodoBackend.Task.Repository.CommentRepo

  describe "comments" do
    alias TodoBackend.Task.Model.Comment

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CommentRepo.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert CommentRepo.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert CommentRepo.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = CommentRepo.create_comment(@valid_attrs)
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
      comment = comment_fixture()
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
