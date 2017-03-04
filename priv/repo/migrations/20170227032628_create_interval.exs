defmodule CPAP.Repo.Migrations.CreateInterval do
  use Ecto.Migration

  def change do
    create table(:intervals) do
      add :months, :integer

      timestamps()
    end

  end
end
