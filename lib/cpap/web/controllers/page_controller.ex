defmodule CPAP.Web.PageController do
  use CPAP.Web, :controller

  def index(conn, _params) do
    orders = if conn.assigns.current_user do
      CPAP.Purchases.list_orders_and_items(conn.assigns.current_user)
      #IO.inspect orders, label: "orders and items"
    else
      []
    end

    render conn, "index.html", orders: orders
  end
end
