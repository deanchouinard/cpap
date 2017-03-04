defmodule CPAP.Repo.Migrations.AddQtyToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :qty, :integer
    end

  end
end
