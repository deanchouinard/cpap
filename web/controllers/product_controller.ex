defmodule CPAP.ProductController do
  use CPAP.Web, :controller

  alias CPAP.Product
  alias CPAP.Interval

  plug :load_intervals when action in [:new, :create, :edit, :update]

  defp load_intervals(conn, _) do
    query =
    Interval
    |> Interval.ascending
    |> Interval.months_and_ids
    intervals = Repo.all query
    assign(conn, :intervals, intervals)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  defp user_products(user) do
    assoc(user, :products)
  end

  def index(conn, _params, user) do
    products = Repo.all(user_products(user))
    products = Repo.preload(products, :interval)
    render(conn, "index.html", products: products)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:products)
      |> Product.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}, user) do
    IO.inspect product_params
    changeset =
      user
      |> build_assoc(:products)
      |> Product.changeset(product_params)

      IO.inspect changeset
    case Repo.insert(changeset) do
      {:ok, _product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: product_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    product = Repo.get!(user_products(user), id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}, user) do
    product = Repo.get!(user_products(user), id)
    changeset = Product.changeset(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}, user) do
    product = Repo.get!(user_products(user), id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: product_path(conn, :show, product))
      {:error, changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    product = Repo.get!(user_products(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: product_path(conn, :index))
  end
end
