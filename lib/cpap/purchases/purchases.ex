defmodule CPAP.Purchases do
  @moduledoc """
  The boundary for the Purchases system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias CPAP.Repo

  alias CPAP.Purchases.Order
  alias CPAP.Purchases.Item
  #  alias CPAP.Product

  defp user_orders(user) do
    Ecto.assoc(user, :orders)
  end

  defp order_items(order) do
    Ecto.assoc(order, :items )
  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(user) do
    Repo.all(user_orders(user))
  end

  def list_orders_and_items(user) do
    Repo.all from o in Order, where: o.user_id == ^user.id,
    order_by: [desc: o.order_date],
    left_join: items in assoc(o, :items),
    left_join: product in assoc(items, :product),
    preload: [items: {items, product: product}]
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id, user), do: Repo.get!(user_orders(user), id)
    |> Repo.preload(items:
    from(i in Item, join: p in assoc(i, :product), preload: [product: p ]))

  def get_items!(order), do: Repo.all(order_items(order)) |> Repo.preload(:product)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}, user) do
    IO.inspect attrs, lable: "create_order"
    od = Map.get(attrs, "order_date")
    attrs = Enum.map(attrs["items"], fn {k, v} -> {k, Map.put(v, "user_id", user.id)}
      end ) |> Enum.into(%{})
    attrs = Map.put(%{}, "items", attrs)
    attrs = Map.put(attrs, "order_date", od)

    user
    |> Ecto.build_assoc(:orders)
    |> order_item_changeset(attrs)
    |> IO.inspect
    |> Repo.insert()
  end

  def create_item(attrs \\ %{}, user, order_id) do
    attrs = Map.put(attrs, "order_id", order_id)
    user
    |> Ecto.build_assoc(:items)
    |> item_changeset(attrs)
    |> IO.inspect(label: "create item*********")
    #    |> put_change(:order_id, String.to_integer(order_id))
    #|> apply_changes()
    #|> IO.inspect 
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs ) do
    order
    |> order_item_changeset(attrs)
    |> IO.inspect
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    order
    |> order_changeset(%{})
  end

  def change_order_item(%Order{} = order) do
    order
    |> order_item_changeset(%{})
  end

  def change_item(%Item{} = item) do
    item
    |> item_changeset(%{})
    |> IO.inspect(label: "change_item")
  end

  #defp item_changeset(%Item{} = item, attrs) do
  def item_changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:qty, :product_id, :order_id, :user_id])
    #|> validate_required([:qty, :product_id, :order_id, :user_id])
    |> validate_required([:qty, :product_id, :user_id])
  end

  defp order_changeset(%Order{} = order, attrs) do
    order
    |> cast(attrs, [:order_date, :user_id])
    |> validate_required([:order_date, :user_id])
  end

  def order_item_changeset(%Order{} = order, params) do
    order
    |> cast(params, [:order_date, :user_id])
    |> validate_required([:order_date, :user_id])
    |> cast_assoc(:items, required: true, with: &item_changeset/2)
  end

end
