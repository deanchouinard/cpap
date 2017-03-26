defmodule CPAP.PurchasesTest do
  use CPAP.DataCase

  alias CPAP.Purchases
  alias CPAP.Purchases.Order

  @create_attrs %{order_date: ~D[2010-04-17]}
  @update_attrs %{order_date: ~D[2011-05-18]}
  @invalid_attrs %{order_date: nil}

  def fixture(:order, attrs \\ @create_attrs) do
    user = insert_user()
    attrs = Map.put(attrs, :user_id, user.id)
    IO.inspect attrs
    {:ok, order} = Purchases.create_order(attrs)
    order
  end

  test "list_orders/1 returns all orders" do
    order = fixture(:order)
    assert Purchases.list_orders() == [order]
  end

  test "get_order! returns the order with given id" do
    order = fixture(:order)
    assert Purchases.get_order!(order.id) == order
  end

  test "create_order/1 with valid data creates a order" do
    assert {:ok, %Order{} = order} = Purchases.create_order(@create_attrs)
    assert order.order_date == ~D[2010-04-17]
  end

  test "create_order/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Purchases.create_order(@invalid_attrs)
  end

  test "update_order/2 with valid data updates the order" do
    order = fixture(:order)
    assert {:ok, order} = Purchases.update_order(order, @update_attrs)
    assert %Order{} = order
    assert order.order_date == ~D[2011-05-18]
  end

  test "update_order/2 with invalid data returns error changeset" do
    order = fixture(:order)
    assert {:error, %Ecto.Changeset{}} = Purchases.update_order(order, @invalid_attrs)
    assert order == Purchases.get_order!(order.id)
  end

  test "delete_order/1 deletes the order" do
    order = fixture(:order)
    assert {:ok, %Order{}} = Purchases.delete_order(order)
    assert_raise Ecto.NoResultsError, fn -> Purchases.get_order!(order.id) end
  end

  test "change_order/1 returns a order changeset" do
    order = fixture(:order)
    assert %Ecto.Changeset{} = Purchases.change_order(order)
  end
end
