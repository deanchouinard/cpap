defmodule CPAP.Web.PageControllerTest do
  use CPAP.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello CPAP!"
  end
end
