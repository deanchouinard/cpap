defmodule CPAP.PageController do
  use CPAP.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
