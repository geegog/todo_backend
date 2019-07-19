defmodule TodoBackendWeb.UserController do
  use TodoBackendWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
