defmodule CPAP.Repo.Migrations.IntervalNotNulls do
  use Ecto.Migration

  def change do
    alter table(:intervals) do
      modify :months, :integer, null: false
    end
  end
end
