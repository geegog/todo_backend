defmodule TodoBackendWeb.UserControllerTest do
  use TodoBackendWeb.ConnCase

  alias TodoBackend.User.Model.User
  alias TodoBackend.User.Repository.UserRepo
  alias TodoBackend.Guardian

  @create_another_attrs %{
    email: "another@email.com",
    name: "another name",
    phone: "another phone",
    password: "anotherpassword",
    password_confirmation: "anotherpassword"
  }

  @create_attrs %{
    email: "some@email.com",
    name: "some name",
    phone: "some phone",
    password: "password",
    password_confirmation: "password"
  }
  @update_attrs %{
    email: "some@updatedemail.com",
    name: "some updated name",
    phone: "some updated phone"
  }
  @invalid_attrs %{email: nil, name: nil, phone: nil}

  def fixture(:user) do
    {:ok, user} = UserRepo.create_user(@create_attrs)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
    %{user: user, jwt: jwt}
  end

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: %{user: _, jwt: jwt} = user} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = get(conn, Routes.user_path(conn, :index))
      assert length(json_response(conn, 200)["data"]) == length([user.user])
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_another_attrs)
      assert %{"jwt" => jwt} = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %{user: %User{id: id}, jwt: jwt} = user} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = put(conn, Routes.user_path(conn, :update, user.user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show))

      assert %{
               "id" => id,
               "email" => "some@updatedemail.com",
               "name" => "some updated name",
               "phone" => "some updated phone"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      jwt = user.jwt
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      conn = put(conn, Routes.user_path(conn, :update, user.user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: %{user: _, jwt: jwt} = user} do
      conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")

      conn = delete(conn, Routes.user_path(conn, :delete, user.user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
