defmodule CPAP.Repo.Migrations.AddUserIdToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:products, [:user_id])

  end
end
