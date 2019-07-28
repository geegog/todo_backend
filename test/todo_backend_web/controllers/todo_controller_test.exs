defmodule TodoBackendWeb.TodoControllerTest do
  use TodoBackendWeb.ConnCase

  alias TodoBackend.Task.Model
  alias TodoBackend.Task.Model.Todo

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
    {:ok, todo} = Model.create_todo(@create_attrs)
    todo
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = get(conn, Routes.todo_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id,
               "deadline" => "2010-04-17T14:00:00",
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id,
               "deadline" => "2011-05-18T15:01:01",
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, Routes.todo_path(conn, :delete, todo))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todo_path(conn, :show, todo))
      end
    end
  end

  defp create_todo(_) do
    todo = fixture(:todo)
    {:ok, todo: todo}
  end
end
