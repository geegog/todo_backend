defmodule TodoBackendWeb.TodoCategoryControllerTest do
  use TodoBackendWeb.ConnCase

  alias TodoBackend.Category.Repository.TodoCategoryRepo
  alias TodoBackend.Category.Model.TodoCategory
  alias TodoBackend.Task.Repository.TodoRepo
  alias TodoBackend.User.Repository.UserRepo
  alias TodoBackend.Category.Repository.CategoryRepo
  alias TodoBackend.Guardian

  @create_category_attrs %{
    name: "some name"
  }
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

  }
  @update_attrs %{

  }
  # @invalid_attrs %{}

  def fixture(:todo_category) do
    todo = todo_fixture(:todo)
    category = category_fixture(:category)
    {:ok, todo_category} = TodoCategoryRepo.create_todo_category(@create_attrs |> Map.put(:todo_id, elem(todo, 0).id) |> Map.put(:category_id, category.id))
    {todo_category, elem(todo, 1)}
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

  def category_fixture(:category) do
    {:ok, category} = CategoryRepo.create_category(@create_category_attrs)
    category
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_todo_category]

    test "lists all todo_categories", %{conn: conn, todo_category: {_, jwt} = todo_category} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = get(conn, Routes.todo_category_path(conn, :index))
      assert Map.get(hd(json_response(conn, 200)["data"]), "id") == elem(todo_category, 0).id
    end
  end

  describe "create todo_category" do
    setup [:create_todo]
    setup [:create_category]

    test "renders todo_category when data is valid", %{conn: conn, todo: {_, jwt} = todo, category: category} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = post(conn, Routes.todo_category_path(conn, :create, category.id, elem(todo, 0).id), todo_category: @create_attrs |> Map.put(:todo_id, elem(todo, 0).id) |> Map.put(:category_id, category.id))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_category_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    # test "renders errors when data is invalid", %{conn: conn, todo: {_, jwt} = todo, category: category} do
    #   conn = conn
    #   |> put_req_header("authorization", "Bearer #{jwt}")

    #   conn = post(conn, Routes.todo_category_path(conn, :create, category.id, elem(todo, 0).id), todo_category: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update todo_category" do
    setup [:create_todo_category]

    test "renders todo_category when data is valid", %{conn: conn, todo_category: {%TodoCategory{id: id}, jwt} = todo_category} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = put(conn, Routes.todo_category_path(conn, :update, elem(todo_category, 0)), todo_category: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_category_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    # test "renders errors when data is invalid", %{conn: conn, todo_category: {%TodoCategory{id: _}, jwt} = todo_category} do
    #   conn = conn
    #   |> put_req_header("authorization", "Bearer #{jwt}")

    #   conn = put(conn, Routes.todo_category_path(conn, :update, elem(todo_category, 0)), todo_category: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete todo_category" do
    setup [:create_todo_category]

    test "deletes chosen todo_category", %{conn: conn, todo_category: {%TodoCategory{id: _}, jwt} = todo_category} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = delete(conn, Routes.todo_category_path(conn, :delete, elem(todo_category, 0)))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todo_category_path(conn, :show, elem(todo_category, 0)))
      end
    end
  end

  defp create_todo_category(_) do
    todo_category = fixture(:todo_category)
    {:ok, todo_category: todo_category}
  end

  defp create_todo(_) do
    todo = todo_fixture(:todo)
    {:ok, todo: todo}
  end

  defp create_category(_) do
    category = category_fixture(:category)
    {:ok, category: category}
  end
end
