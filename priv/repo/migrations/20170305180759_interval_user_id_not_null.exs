defmodule CPAP.Repo.Migrations.IntervalUserIdNotNull do
  use Ecto.Migration

  def change do
    alter table(:intervals) do
      modify :user_id, :integer, null: false
    end

  end
end
