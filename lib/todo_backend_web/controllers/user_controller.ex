defmodule TodoBackendWeb.UserController do
  use TodoBackendWeb, :controller

  alias TodoBackend.User.Repository.UserRepo
  alias TodoBackend.User.Model.User
  alias TodoBackend.Guardian

  action_fallback TodoBackendWeb.FallbackController

  def index(conn, _params) do
    users = UserRepo.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserRepo.create_user(user_params),
        {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show))
      |> render("jwt.json", jwt: token)
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("show.json", user: user)
 end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserRepo.get_user!(id)

    with {:ok, %User{} = user} <- UserRepo.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserRepo.get_user!(id)

    with {:ok, %User{}} <- UserRepo.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case UserRepo.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end
end
