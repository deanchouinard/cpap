defmodule CPAP.Web.ItemController do
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

  # def index(conn, _params, user) do
  #   orders = Purchases.list_orders(user)
  #   render(conn, "index.html", orders: orders)
  # end

    def new(conn, %{"order_id" => order_id}, _user) do
#  def new(conn, params, _user) do
    changeset = Purchases.change_item(%CPAP.Purchases.Item{})
    #changeset = Purchases.change_item(%CPAP.Purchases.Item{}, order_id)
    #order = %{id:  order}
    #IO.inspect order_id, label: "item_new"
    #render(conn, "new.html", changeset: changeset, order_id: order_id)
    render(conn, "new.html", changeset: changeset, order_id: order_id)
  end

  def create(conn, %{"item" => item_params, "order_id" => order_id}, user) do
#  def create(conn, item_params, user) do
    IO.inspect item_params, label: "item_params"
    case Purchases.create_item(item_params, user, order_id) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        #|> redirect(to: order_path(conn, :show, order))
        |> redirect(to: order_path(conn, :show, order_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, order_id: order_id)
    end
  end
end

