defmodule CPAP.Purchases.Order do
  use Ecto.Schema

  schema "purchases_orders" do
    field :order_date, :date
    belongs_to(:user, User)
    has_many(:items, CPAP.Purchases.Item)

    timestamps()
  end
end
