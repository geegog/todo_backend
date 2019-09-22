defmodule TodoBackendWeb.CommentView do
  use TodoBackendWeb, :view
  alias TodoBackendWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{
      data: render_many(comments, CommentView, "comment.json"),
      metadata: %{
        page_number: comments.page_number,
        page_size: comments.page_size,
        total_pages: comments.total_pages,
        total_entries: comments.total_entries
      }
    }
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      text: comment.text,
      user: %{
        id: comment.user.id,
        email: comment.user.email,
        phone: comment.user.phone,
        name: comment.user.name
      },
      todo: %{
        id: comment.todo.id,
        deadline: comment.todo.deadline,
        description: comment.todo.description,
        title: comment.todo.title
      }
    }
  end
end
