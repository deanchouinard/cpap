defmodule CPAP.Web.PageController do
  use CPAP.Web, :controller

  def index(conn, _params) do
    {orders, products_needed} = if conn.assigns.current_user do
      {CPAP.Purchases.list_orders_and_items(conn.assigns.current_user), 
        CPAP.Purchases.Reports.suggested_order(conn.assigns.current_user)}
    else
      {[], []}
    end

    render conn, "index.html", orders: orders, products_needed: products_needed
  end
end
