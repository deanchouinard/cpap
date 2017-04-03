defmodule CPAP.Web.OrderControllerTest do
  use CPAP.Web.ConnCase

  alias CPAP.Purchases

  @create_attrs %{order_date: ~D[2010-04-17]}
  @update_attrs %{order_date: ~D[2011-05-18]}
  @invalid_attrs %{order_date: nil}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(%{username: username})
      conn = assign(build_conn(), :current_user, user)
      order = insert_order(user)
      #      interval = insert_interval(user, %{months: 3})
      #   product_attrs = Map.merge(@valid_attrs, %{user_id: user.id,
      #   interval_id: interval.id})
      # product = insert_product(user, product_attrs)
      #
      # {:ok, conn: conn, user: user, product: product, product_attrs:
      #   product_attrs}
      {:ok, conn: conn, order: order}
    else
      :ok
    end
  end

  def fixture(:order, user) do
    #   user = insert_user()
    # attrs = Map.put(@create_attrs, :user_id, user.id)
    {:ok, order} = Purchases.create_order(@create_attrs, user)
    order
  end

  @tag login_as: "max"
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, order_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Orders"
  end

  @tag login_as: "max"
  test "renders form for new orders", %{conn: conn} do
    conn = get conn, order_path(conn, :new)
    assert html_response(conn, 200) =~ "New Order"
  end

  @tag login_as: "max"
  test "creates order and redirects to show when data is valid", %{conn: conn} do
    # attrs = Map.put(@create_attrs, :user_id, conn.assigns.current_user.id)
    # conn = post conn, order_path(conn, :create), order: attrs
    conn = post conn, order_path(conn, :create), order: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == order_path(conn, :show, id)
    IO.inspect conn.assigns.current_user, label: "Test"
    IO.inspect id
    conn = get conn, order_path(conn, :show, id)
    IO.inspect conn.assigns.current_user, label: "Test2"
    assert html_response(conn, 200) =~ "Show Order"

    #assert redirected_to(conn) == order_path(conn, :show, id)
    #    IO.inspect conn, label: "Test"

    # conn = get conn, order_path(conn, :show, id)
    # assert html_response(conn, 200) =~ "Show Order"
  end

  @tag login_as: "max"
  test "order show", %{conn: conn, order: order} do
    conn = get conn, order_path(conn, :show, order.id)
    assert html_response(conn, 200) =~ "Show Order"
  end

  @tag login_as: "max"
  test "does not create order and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, order_path(conn, :create), order: @invalid_attrs
    assert html_response(conn, 200) =~ "New Order"
  end

  @tag login_as: "max"
  test "renders form for editing chosen order", %{conn: conn} do
    order = fixture(:order, conn.assigns.current_user)
    conn = get conn, order_path(conn, :edit, order)
    assert html_response(conn, 200) =~ "Edit Order"
  end

  @tag login_as: "max"
  test "updates chosen order and redirects when data is valid", %{conn: conn} do
    order = fixture(:order, conn.assigns.current_user)
    conn = put conn, order_path(conn, :update, order), order: @update_attrs
    assert redirected_to(conn) == order_path(conn, :show, order)

    conn = get conn, order_path(conn, :show, order)
    assert html_response(conn, 200)
  end

  @tag login_as: "max"
  test "does not update chosen order and renders errors when data is invalid", %{conn: conn} do
    order = fixture(:order, conn.assigns.current_user)
    conn = put conn, order_path(conn, :update, order), order: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Order"
  end

  @tag login_as: "max"
  test "deletes chosen order", %{conn: conn} do
    order = fixture(:order, conn.assigns.current_user)
    conn = delete conn, order_path(conn, :delete, order)
    assert redirected_to(conn) == order_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, order_path(conn, :show, order)
    end
  end

end
