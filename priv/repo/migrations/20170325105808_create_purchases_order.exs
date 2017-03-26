defmodule CPAP.Repo.Migrations.CreateCPAP.Purchases.Order do
  use Ecto.Migration

  def change do
    create table(:purchases_orders) do
      add :order_date, :date, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:purchases_orders, [:user_id])

  end
end
