defmodule CPAP.Purchases do
  @moduledoc """
  The boundary for the Purchases system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias CPAP.Repo

  alias CPAP.Purchases.Order
  alias CPAP.Purchases.Item
  alias CPAP.Product

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
    # %Order{}
    user
    |> Ecto.build_assoc(:orders)
    |> order_changeset(attrs)
    |> Repo.insert()
  end

  def create_item(attrs \\ %{}, user) do
  #    attrs = Map.put(attrs, :order_id, order.id)
    user
    |> Ecto.build_assoc(:items)
    |> item_changeset(attrs)
    |> IO.inspect 
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
    |> order_changeset(attrs)
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
    # user
    # |> Ecto.build_assoc(:orders)
    order
    |> order_changeset(%{})
  end

  def change_item(%Item{} = item, order) do
    item
    |> item_changeset(%{})
    |> put_change(:order_id, order)
    |> IO.inspect label: "change_item"
  end

  defp item_changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:qty, :product_id, :order_id, :user_id])
    |> validate_required([:qty, :product_id, :order_id, :user_id])
  end

  defp order_changeset(%Order{} = order, attrs) do
    order
    |> cast(attrs, [:order_date, :user_id])
    |> validate_required([:order_date, :user_id])
  end
end
