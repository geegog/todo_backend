defmodule TodoBackendWeb.CommentController do
  use TodoBackendWeb, :controller

  alias TodoBackend.Task.Repository.CommentRepo
  alias TodoBackend.User.Repository.UserRepo
  alias TodoBackend.Task.Repository.TodoRepo
  alias TodoBackend.Task.Model.Comment

  action_fallback TodoBackendWeb.FallbackController

  def index(conn, _params) do
    comments = CommentRepo.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"user_id" => user_id, "todo_id" => todo_id, "comment" => comment_params}) do
    user = UserRepo.get_user!(user_id)
    todo = TodoRepo.get_todo!(todo_id)

    with {:ok, %Comment{} = comment} <- CommentRepo.create_comment(Map.put(comment_params, "user_id", user.id) |> Map.put("todo_id", todo.id)) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = CommentRepo.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = CommentRepo.get_comment!(id)

    with {:ok, %Comment{} = comment} <- CommentRepo.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = CommentRepo.get_comment!(id)

    with {:ok, %Comment{}} <- CommentRepo.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
