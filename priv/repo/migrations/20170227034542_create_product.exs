defmodule CPAP.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :code, :string
      add :desc, :text
      add :interval_id, references(:intervals, on_delete: :nothing)

      timestamps()
    end
    create index(:products, [:interval_id])

  end
end
