defmodule TodoBackendWeb.CommentControllerTest do
  use TodoBackendWeb.ConnCase

  alias TodoBackend.Task.Repository.CommentRepo
  alias TodoBackend.Task.Repository.TodoRepo
  alias TodoBackend.User.Repository.UserRepo
  alias TodoBackend.Task.Model.Comment
  alias TodoBackend.Task.Model.Todo
  alias TodoBackend.Guardian

  @create_user_attrs %{
    email: "some@email.com",
    name: "some name",
    phone: "some phone",
    password: "password",
    password_confirmation: "password"
  }

  @create_todo_attrs %{
    deadline: ~N[2010-04-17 14:00:00],
    description: "some description",
    title: "some title"
  }
  @create_attrs %{
    text: "some text"
  }
  @update_attrs %{
    text: "some updated text"
  }
  @invalid_attrs %{text: nil}

  def fixture(:comment) do
    todo = todo_fixture(:todo)
    {:ok, comment} = CommentRepo.create_comment(@create_attrs |> Map.put(:todo_id, elem(todo, 0).id) |> Map.put(:user_id, elem(todo, 0).user_id))
    {comment, elem(todo, 1)}
  end

  def todo_fixture(:todo) do
    user = user_fixture(:user)
    {:ok, todo} = TodoRepo.create_todo(@create_todo_attrs |> Map.put(:user_id, user.user.id))
    {todo, user.jwt}
  end

  def user_fixture(:user) do
    {:ok, user} = UserRepo.create_user(@create_user_attrs)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
    %{user: user, jwt: jwt}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_comment]
    test "lists all comments", %{conn: conn, comment: comment} do
      jwt = elem(comment, 1)
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = get(conn, Routes.comment_path(conn, :index))
      assert length(json_response(conn, 200)["data"]) == length([elem(comment, 0)])
    end
  end

  describe "create comment" do
    setup [:create_todo]

    test "renders comment when data is valid", %{conn: conn, todo: {%Todo{id: _}, jwt} = todo} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = post(conn, Routes.comment_path(conn, :create, elem(todo, 0).user_id,  elem(todo, 0).id), comment: @create_attrs |> Map.put(:todo_id, elem(todo, 0).id) |> Map.put(:user_id, elem(todo, 0).user_id))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.comment_path(conn, :show, id))

      assert %{
               "id" => id,
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: {%Todo{id: _}, jwt} = todo} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = post(conn, Routes.comment_path(conn, :create, elem(todo, 0).user_id,  elem(todo, 0).id), comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update comment" do
    setup [:create_comment]

    test "renders comment when data is valid", %{conn: conn, comment: {%Comment{id: id}, jwt} = comment} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = put(conn, Routes.comment_path(conn, :update, elem(comment, 0)), comment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.comment_path(conn, :show, id))

      assert %{
               "id" => id,
               "text" => "some updated text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, comment: {%Comment{id: _}, jwt} = comment} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = put(conn, Routes.comment_path(conn, :update, elem(comment, 0)), comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete comment" do
    setup [:create_comment]

    test "deletes chosen comment", %{conn: conn, comment: {%Comment{id: _}, jwt} = comment} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = delete(conn, Routes.comment_path(conn, :delete, elem(comment, 0)))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.comment_path(conn, :show, elem(comment, 0)))
      end
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
    {:ok, comment: comment}
  end

  defp create_todo(_) do
    todo = todo_fixture(:todo)
    {:ok, todo: todo}
  end
end
