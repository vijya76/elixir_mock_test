defmodule TestTaskWeb.PageController do
  use TestTaskWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
