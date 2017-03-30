defmodule CPAP.Purchases.Item do
  use Ecto.Schema

  schema "purchases_items" do
    field :qty, :integer
    belongs_to(:user, User)
    belongs_to(:order, Order)
    belongs_to(:product, CPAP.Product)

    timestamps()
  end
end
