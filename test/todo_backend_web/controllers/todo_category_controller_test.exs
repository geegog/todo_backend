defmodule TodoBackendWeb.TodoCategoryControllerTest do
  use TodoBackendWeb.ConnCase

  alias TodoBackend.Category.Model
  alias TodoBackend.Category.Model.TodoCategory

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:todo_category) do
    {:ok, todo_category} = Model.create_todo_category(@create_attrs)
    todo_category
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todo_categories", %{conn: conn} do
      conn = get(conn, Routes.todo_category_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo_category" do
    test "renders todo_category when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_category_path(conn, :create), todo_category: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_category_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_category_path(conn, :create), todo_category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo_category" do
    setup [:create_todo_category]

    test "renders todo_category when data is valid", %{conn: conn, todo_category: %TodoCategory{id: id} = todo_category} do
      conn = put(conn, Routes.todo_category_path(conn, :update, todo_category), todo_category: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_category_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo_category: todo_category} do
      conn = put(conn, Routes.todo_category_path(conn, :update, todo_category), todo_category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo_category" do
    setup [:create_todo_category]

    test "deletes chosen todo_category", %{conn: conn, todo_category: todo_category} do
      conn = delete(conn, Routes.todo_category_path(conn, :delete, todo_category))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todo_category_path(conn, :show, todo_category))
      end
    end
  end

  defp create_todo_category(_) do
    todo_category = fixture(:todo_category)
    {:ok, todo_category: todo_category}
  end
end
