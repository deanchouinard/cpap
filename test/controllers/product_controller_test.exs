defmodule CPAP.Web.ProductControllerTest do
  use CPAP.Web.ConnCase

  alias CPAP.Product
  @valid_attrs %{qty: 1, code: "ACODE", desc: "A desc"}
  @invalid_attrs %{code: ""}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(%{username: username})
      conn = assign(build_conn(), :current_user, user)
      interval = insert_interval(user, %{months: 3})
      product_attrs = Map.merge(@valid_attrs, %{user_id: user.id,
        interval_id: interval.id})
      product = insert_product(user, product_attrs)

      {:ok, conn: conn, user: user, product: product, product_attrs:
        product_attrs}
    else
      :ok
    end
  end

  test "requires user authneticaton on all actons", %{conn: conn} do
    Enum.each([
      get(conn, product_path(conn, :new)),
      get(conn, product_path(conn, :index)),
      get(conn, product_path(conn, :show, "123")),
      get(conn, product_path(conn, :edit, "123")),
      put(conn, product_path(conn, :update, "123", %{})),
      post(conn, product_path(conn, :create, %{})),
      delete(conn, product_path(conn, :delete, "123")),
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end

  @tag login_as: "max"
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, product_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing products"
  end

  @tag login_as: "max"
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, product_path(conn, :new)
    assert html_response(conn, 200) =~ "New product"
  end

  defp product_count(query), do: Repo.one(from p in query, select: count(p.id))

  @tag login_as: "max"
  test "creates resource and redirects when data is valid", %{conn: conn, 
        user: user, product_attrs: product_attrs} do
    product_attrs = Map.merge(product_attrs, %{code: "TEST"})
    conn = post conn, product_path(conn, :create), product: product_attrs
    assert redirected_to(conn) == product_path(conn, :index)
    assert Repo.get_by!(Product, product_attrs).user_id == user.id
  end

  @tag login_as: "max"
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    count_before = product_count(Product)
    conn = post conn, product_path(conn, :create), product: @invalid_attrs
    assert html_response(conn, 200) =~ "New product"
    assert product_count(Product) == count_before
  end

  @tag login_as: "max"
  test "shows chosen resource", %{conn: conn, product: product} do
    # changeset = Product.changeset(product)
    # product = Repo.insert! changeset
    conn = get conn, product_path(conn, :show, product)
    assert html_response(conn, 200) =~ "Show product"
  end

  @tag login_as: "max"
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, product_path(conn, :show, -1)
    end
  end

  @tag login_as: "max"
  test "renders form for editing chosen resource", %{conn: conn, product:
    product} do
    # product = Repo.insert! %Product{}
    conn = get conn, product_path(conn, :edit, product)
    assert html_response(conn, 200) =~ "Edit product"
  end

  @tag login_as: "max"
  test "updates chosen resource and redirects when data is valid", %{conn: conn,
  product: product} do
    # product = Repo.insert! %Product{}
    conn = put conn, product_path(conn, :update, product), product: @valid_attrs
    assert redirected_to(conn) == product_path(conn, :show, product)
    assert Repo.get_by(Product, @valid_attrs)
  end

  @tag login_as: "max"
  test "does not update chosen resource and renders errors when data is
  invalid", %{conn: conn, product: product} do
    # product = Repo.insert! %Product{}
    conn = put conn, product_path(conn, :update, product), product: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit product"
  end

  @tag login_as: "max"
  test "deletes chosen resource", %{conn: conn, product: product} do
    #  product = Repo.insert! %Product{}
    conn = delete conn, product_path(conn, :delete, product)
    assert redirected_to(conn) == product_path(conn, :index)
    refute Repo.get(Product, product.id)
  end

  @tag login_as: "max"
  test "authorizes actions against access by other users",
    %{conn: conn, product: product } do
      non_owner = insert_user(%{username: "sneaky"})
      conn = assign(conn, :current_user, non_owner)

      assert_error_sent :not_found, fn ->
        get(conn, product_path(conn, :show, product))
      end
      assert_error_sent :not_found, fn ->
        get(conn, product_path(conn, :edit, product))
      end
      assert_error_sent :not_found, fn ->
        put(conn, product_path(conn, :update, product, product: @valid_attrs))
      end
      assert_error_sent :not_found, fn ->
        delete(conn, product_path(conn, :delete, product))
      end
    end
end
