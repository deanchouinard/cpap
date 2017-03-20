defmodule CPAP.Interval do
  use CPAP.Web, :model

  schema "intervals" do
    field :months, :integer
    has_many :products, CPAP.Product
    belongs_to :user, CPAP.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:months])
    |> validate_required([:months])
  end
  
  def ascending(query) do
    from i in query, order_by: i.months
  end

  def months_and_ids(query) do
    from i in query, select: {i.months, i.id}
  end

  def id_to_months(id) do
    CPAP.Repo.one from i in CPAP.Interval, select: i.months, where: ^id == i.id
  end

end
