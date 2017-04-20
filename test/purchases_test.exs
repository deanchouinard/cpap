defmodule CPAP.PurchasesTest do
  use CPAP.DataCase

  alias CPAP.Purchases
  alias CPAP.Purchases.Order
  alias CPAP.Purchases.Item

  @create_attrs %{"items" => %{"0" => %{"qty" => "1", "product_id" => "1"}}, "order_date" => ~D[2010-04-17]}
  @update_attrs %{order_date: ~D[2011-05-18]}
  #@invalid_attrs %{"order_date" => nil, "items" => nil}
  @invalid_attrs %{"items" => %{"0" => %{"qty" => "1", "product_id" => "1"}},
    "order_date" => nil}
  @item_attrs %{qty: 1}

  def fixture(:order, attrs \\ @create_attrs) do
    user = insert_user()
    interval = insert_interval(user, %{months: 3})
    product = insert_product(user, %{code: "A", desc: "A desc", qty: 1,
        interval_id: interval.id})
    order_attrs = put_in(@create_attrs, ["items", "0", "product_id"], product.id)
    # attrs = Map.put(attrs, :user_id, user.id)
    #    IO.inspect attrs
    {:ok, order} = Purchases.create_order(order_attrs, user)
    {user, order}
  end

  test "list_orders/1 returns all orders" do
    {user, order} = fixture(:order)
    assert Purchases.list_orders(user) |> Repo.preload(:items) == [order]
  end

  test "list item for an order" do
    {user, order} = fixture(:order)
    interval = insert_interval(user, %{months: 1})
    product = insert_product(user, %{code: "TEST", desc: "A test", qty: 1,
      interval_id: interval.id})

    {:ok, item} = Purchases.create_item(%{"qty" => 1, "product_id" =>product.id}, user,
    order.id)
    assert item.product_id == product.id
  end

  test "get_order! returns the order with given id" do
    {user, order} = fixture(:order)
    order = Repo.preload(order, [items: from(i in Item,
      join: p in assoc(i, :product), preload: [product: p ] )], force: true )
    assert Purchases.get_order!(order.id, user) == order
  end

  @tag :skip
  test "create_order/1 with valid data creates a order" do
    user = insert_user()
    assert {:ok, %Order{} = order} = Purchases.create_order(@create_attrs, user)
    assert order.order_date == ~D[2010-04-17]
  end

  test "create_order/1 with invalid data returns error changeset" do
    user = insert_user()
    assert {:error, %Ecto.Changeset{}} = Purchases.create_order(@invalid_attrs,
    user)
  end

  test "update_order/2 with valid data updates the order" do
    {_user, order} = fixture(:order)
    assert {:ok, order} = Purchases.update_order(order, @update_attrs)
    assert %Order{} = order
    assert order.order_date == ~D[2011-05-18]
  end

  test "update_order/2 with invalid data returns error changeset" do
    {user, order} = fixture(:order)
    invalid_attrs = %{"order_date" => nil}
    assert {:error, %Ecto.Changeset{}} = Purchases.update_order(order, invalid_attrs)
    IO.inspect order, label: "before"
    order = Repo.preload(order, [items: from(i in Item,
      join: p in assoc(i, :product), preload: [product: p ] )], force: true )
    IO.inspect order, label: "order"
    assert order == Purchases.get_order!(order.id, user)
  end

  test "delete_order/1 deletes the order" do
    {user, order} = fixture(:order)
    assert {:ok, %Order{}} = Purchases.delete_order(order)
    assert_raise Ecto.NoResultsError, fn -> Purchases.get_order!(order.id, user) end
  end

  test "change_order/1 returns a order changeset" do
    {_user, order} = fixture(:order)
    assert %Ecto.Changeset{} = Purchases.change_order(order)
  end
end
