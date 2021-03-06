defmodule CPAP.Web.OrderControllerTest do
  use CPAP.Web.ConnCase

  alias CPAP.Purchases

  @create_attrs %{"items" => %{"0" => %{"qty" => "1", "product_id" => "1"}}, "order_date" => ~D[2010-04-17]}
  @update_attrs %{order_date: ~D[2011-05-18]}
  #@invalid_attrs %{"order_date" => nil, "items" => nil}
  @invalid_attrs %{"items" => %{"0" => %{"qty" => "1", "product_id" => "1"}},
    "order_date" => nil}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(%{username: username})
      conn = assign(build_conn(), :current_user, user)
      interval = insert_interval(user, %{months: 3})
      product = insert_product(user, %{code: "A", desc: "A desc", qty: 1,
        interval_id: interval.id})
      order_attrs = put_in(@create_attrs, ["items", "0", "product_id"], product.id)
      IO.inspect order_attrs
      
      {:ok, order} = insert_order(user, order_attrs)
      #      interval = insert_interval(user, %{months: 3})
      #   product_attrs = Map.merge(@valid_attrs, %{user_id: user.id,
      #   interval_id: interval.id})
      # product = insert_product(user, product_attrs)
      #
      # {:ok, conn: conn, user: user, product: product, product_attrs:
      #   product_attrs}
      {:ok, conn: conn, order: order, user: user, order_attrs: order_attrs}
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
  test "creates order and redirects to show when data is valid", %{conn: conn,
    user: user, order_attrs: order_attrs} do
    # attrs = Map.put(@create_attrs, :user_id, conn.assigns.current_user.id)
    # conn = post conn, order_path(conn, :create), order: attrs
    # attrs = %{order_date: ~D[2010-04-17], user_id: user.id}
    conn = post conn, order_path(conn, :create), order: order_attrs
    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == order_path(conn, :show, id)
    IO.inspect id, label: "id"
    conn = get conn, order_path(conn, :show, id)
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
  test "does not create order and renders errors when data is invalid", %{conn:
    conn} do
    conn = post conn, order_path(conn, :create), order: @invalid_attrs
    assert html_response(conn, 200) =~ "New Order"
  end

  @tag login_as: "max"
  test "renders form for editing chosen order", %{conn: conn, order: order} do
#    order = fixture(:order, conn.assigns.current_user)
    conn = get conn, order_path(conn, :edit, order)
    assert html_response(conn, 200) =~ "Edit Order"
  end

  @tag login_as: "max"
  test "updates chosen order and redirects when data is valid", %{conn: conn,
    order: order} do
    #order = fixture(:order, conn.assigns.current_user)
    conn = put conn, order_path(conn, :update, order), order: @update_attrs
    assert redirected_to(conn) == order_path(conn, :show, order)

    IO.inspect conn.assigns[:current_user], label: "current_user"
    # not sure why I have to build a new conn to get this to work
    conn = assign(build_conn(), :current_user, conn.assigns.current_user)
    conn = get conn, order_path(conn, :show, order)
    assert html_response(conn, 200)
  end

  @tag login_as: "max"
  test "does not update chosen order and renders errors when data is invalid",
  %{conn: conn, order: order} do
    #order = fixture(:order, conn.assigns.current_user)
    #invalid_attrs = put_in(order_attrs, ["order_date"], nil)
    # IO.inspect invalid_attrs, label: "invalid"
    invalid_attrs = %{"order_date" => nil}
    conn = put conn, order_path(conn, :update, order), order: invalid_attrs
    assert html_response(conn, 200) =~ "Edit Order"
  end

  @tag login_as: "max"
  test "deletes chosen order", %{conn: conn, order: order} do
    #order = fixture(:order, conn.assigns.current_user)
    conn = delete conn, order_path(conn, :delete, order)
    assert redirected_to(conn) == order_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, order_path(conn, :show, order)
    end
  end

end
