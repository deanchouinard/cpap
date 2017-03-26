defmodule CPAP.Repo.Migrations.CreatePurchasesOrderItems do
  use Ecto.Migration

  def change do
    create table(:purchases_items) do
      add :qty, :integer, null: false

      add :order_id, references(:purchases_orders), null: false
      add :user_id, references(:users), null: false
      add :product_id, references(:products), null: false

      timestamps()
    end

    create index(:purchases_items, [:order_id])
    create index(:purchases_items, [:user_id])
    create index(:purchases_items, [:product_id])

  end

end
