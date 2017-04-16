defmodule CPAP.Web.OrderController do
  use CPAP.Web, :controller

  alias CPAP.Purchases
  alias CPAP.Product

  plug :load_products when action in [:new, :create]

  defp load_products(conn, _) do
    query =
      Product
      |> Product.codes_and_ids(conn.assigns.current_user)

    products = Repo.all query
    assign(conn, :products, products)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    orders = Purchases.list_orders(user)
    render(conn, "index.html", orders: orders)
  end

  def new(conn, _params, _user) do
    changeset = Purchases.change_order_item(%CPAP.Purchases.Order{items:
    make_4_items()})
    render(conn, "new.html", changeset: changeset)
  end

  defp make_4_items, do: for _ <- 1..4, do: %CPAP.Purchases.Item{}

  def create(conn, %{"order" => order_params}, user) do
    case Purchases.create_order(order_params, user) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: order_path(conn, :show, order))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    order = Purchases.get_order!(id, user)
    #items = Purchases.get_items!(order)
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}, user) do
    order = Purchases.get_order!(id, user)
    #    IO.inspect order, label: "order @ edit"
    # changeset = Purchases.change_order(order)
    changeset = Purchases.change_order_item(order)
    IO.inspect changeset, label: "edit"
    render(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}, user) do
    order = Purchases.get_order!(id, user)

    case Purchases.update_order(order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: order_path(conn, :show, order))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    order = Purchases.get_order!(id, user)
    {:ok, _order} = Purchases.delete_order(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: order_path(conn, :index))
  end
end
