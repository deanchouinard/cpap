defmodule CPAP.Repo.Migrations.ProductNotNull do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :code, :string, null: false
      modify :desc, :text, null: false
      modify :qty, :integer, null: false
      modify :interval_id, :integer, null: false
      modify :user_id, :integer, null: false
    end

  end
end
