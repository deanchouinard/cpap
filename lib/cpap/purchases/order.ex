defmodule CPAP.Purchases.Order do
  use Ecto.Schema

  schema "purchases_orders" do
    field :order_date, :date
    belongs_to(:user, User)

    timestamps()
  end
end
