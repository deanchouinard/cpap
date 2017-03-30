defmodule CPAP.Product do
  use CPAP.Web, :model

  schema "products" do
    field :code, :string
    field :desc, :string
    field :qty, :integer
    belongs_to :interval, CPAP.Interval
    belongs_to :user, CPAP.User
    has_many :items, CPAP.Purchases.Item

    timestamps()
  end

  def codes_and_ids(query, user) do
    from p in query, select: {p.code, p.id},
      where: p.user_id == ^user.id,
      order_by: p.code
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :desc, :qty, :interval_id])
    |> validate_required([:code, :desc, :qty])
    |> assoc_constraint(:interval)
  end

end
