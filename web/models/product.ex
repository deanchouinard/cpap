defmodule CPAP.Product do
  use CPAP.Web, :model

  schema "products" do
    field :code, :string
    field :desc, :string
    field :qty, :integer
    belongs_to :interval, CPAP.Interval
    belongs_to :user, CPAP.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :desc, :qty, :interval_id])
    |> validate_required([:code, :desc, :qty])
  end


end
