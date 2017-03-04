defmodule CPAP.Repo.Migrations.AddUserIdToIntervals do
  use Ecto.Migration

  def change do
    alter table(:intervals) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:intervals, [:user_id])

  end
end
