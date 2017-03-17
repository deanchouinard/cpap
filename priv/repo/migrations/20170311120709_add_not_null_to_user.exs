defmodule CPAP.Repo.Migrations.AddNotNullToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :name, :string, null: false
      modify :password_hash, :string, null: false
    end
  end
end
