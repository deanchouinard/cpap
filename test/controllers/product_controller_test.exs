defmodule CPAP.Web.ProductControllerTest do
  use CPAP.Web.ConnCase

  alias CPAP.Product
  #  @valid_attrs %{code: "some content", desc: "some content"}
  @invalid_attrs %{code: ""}

  setup do
    user = insert_user(%{username: "max"})
    conn = assign(build_conn(), :current_user, user)
    interval = insert_interval(user, %{months: 3})
    product_attrs = %{user_id: user.id, interval_id: interval.id, qty: 1,
      code: "ACODE", desc: "A desc"}
    product = insert_product(user, product_attrs)

    {:ok, conn: conn, user: user, product: product, product_attrs: product_attrs}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, product_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing products"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, product_path(conn, :new)
    assert html_response(conn, 200) =~ "New product"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, 
        product_attrs: product_attrs} do
    product_attrs = Map.merge(product_attrs, %{code: "TEST"})
    conn = post conn, product_path(conn, :create), product: product_attrs
    assert redirected_to(conn) == product_path(conn, :index)
    assert Repo.get_by(Product, product_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, product_path(conn, :create), product: @invalid_attrs
    assert html_response(conn, 200) =~ "New product"
  end

  test "shows chosen resource", %{conn: conn, product: product} do
    # changeset = Product.changeset(product)
    # product = Repo.insert! changeset
    conn = get conn, product_path(conn, :show, product)
    assert html_response(conn, 200) =~ "Show product"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, product_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, product:
    product} do
    # product = Repo.insert! %Product{}
    conn = get conn, product_path(conn, :edit, product)
    assert html_response(conn, 200) =~ "Edit product"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn,
  product: product, product_attrs: product_attrs} do
    # product = Repo.insert! %Product{}
    conn = put conn, product_path(conn, :update, product), product:
    product_attrs
    assert redirected_to(conn) == product_path(conn, :show, product)
    assert Repo.get_by(Product, product_attrs)
  end

  test "does not update chosen resource and renders errors when data is
  invalid", %{conn: conn, product: product} do
    # product = Repo.insert! %Product{}
    conn = put conn, product_path(conn, :update, product), product: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit product"
  end

  test "deletes chosen resource", %{conn: conn, product: product} do
    #  product = Repo.insert! %Product{}
    conn = delete conn, product_path(conn, :delete, product)
    assert redirected_to(conn) == product_path(conn, :index)
    refute Repo.get(Product, product.id)
  end
end
