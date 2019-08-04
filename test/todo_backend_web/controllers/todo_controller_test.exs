defmodule TodoBackendWeb.TodoControllerTest do
  use TodoBackendWeb.ConnCase

  alias TodoBackend.Task.Model.Todo
  alias TodoBackend.User.Model.User
  alias TodoBackend.Task.Repository.TodoRepo
  alias TodoBackend.User.Repository.UserRepo
  alias TodoBackend.Guardian

  @create_user_attrs %{
    email: "some@email.com",
    name: "some name",
    phone: "some phone",
    password: "password",
    password_confirmation: "password"
  }

  @create_attrs %{
    deadline: ~N[2010-04-17 14:00:00],
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    deadline: ~N[2011-05-18 15:01:01],
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{deadline: nil, description: nil, title: nil}

  def fixture(:todo) do
    user = user_fixture(:user)
    {:ok, todo} = TodoRepo.create_todo(@create_attrs |> Map.put(:user_id, user.user.id))
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
    setup [:create_todo]

    test "lists all todos", %{conn: conn, todo: todo} do
      jwt = elem(todo, 1)
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = get(conn, Routes.todo_path(conn, :index))
      assert length(json_response(conn, 200)["data"]) == length([elem(todo, 0)])
    end
  end

  describe "create todo" do
    setup [:create_user]

    test "renders todo when data is valid", %{conn: conn, user: %{user: %User{id: id}, jwt: jwt} = user} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = post(conn, Routes.todo_path(conn, :create, user.user), todo: @create_attrs |> Map.put(:user_id, id))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id,
               "deadline" => "2010-04-17T14:00:00",
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: %{user: %User{id: _}, jwt: jwt} = user} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = post(conn, Routes.todo_path(conn, :create, user.user), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "renders todo when data is valid", %{conn: conn, todo: {%Todo{id: id}, jwt} = todo} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = put(conn, Routes.todo_path(conn, :update, elem(todo, 0)), todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id,
               "deadline" => "2011-05-18T15:01:01",
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: {%Todo{id: _}, jwt} = todo} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = put(conn, Routes.todo_path(conn, :update, elem(todo, 0)), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: {%Todo{id: _}, jwt} = todo} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = delete(conn, Routes.todo_path(conn, :delete, elem(todo, 0)))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todo_path(conn, :show, elem(todo, 0)))
      end
    end
  end

  defp create_todo(_) do
    todo = fixture(:todo)
    {:ok, todo: todo}
  end

  defp create_user(_) do
    user = user_fixture(:user)
    {:ok, user: user}
  end
end
