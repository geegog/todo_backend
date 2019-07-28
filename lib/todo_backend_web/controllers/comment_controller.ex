defmodule TodoBackendWeb.CommentController do
  use TodoBackendWeb, :controller

  alias TodoBackend.Task.Model
  alias TodoBackend.Task.Model.Comment

  action_fallback TodoBackendWeb.FallbackController

  def index(conn, _params) do
    comments = Model.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Model.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.comment_path(conn, :show, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Model.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Model.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Model.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Model.get_comment!(id)

    with {:ok, %Comment{}} <- Model.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
