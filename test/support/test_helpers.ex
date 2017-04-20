defmodule CPAP.TestHelpers do
  alias CPAP.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      name: "Test User",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      password: "temppass"
    }, attrs)

    %CPAP.User{}
    |> CPAP.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_interval(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:intervals, attrs)
    |> Repo.insert!()
  end

  def insert_product(user, attrs \\ %{}) do
  #j    changes = Map.merge(%{user_id: user.id}, attrs)
    # %CPAP.Product{}
    Ecto.build_assoc(user, :products)
    |> CPAP.Product.changeset(attrs)
    |> Repo.insert!()
  end

  def insert_order(user, attrs) do
    # user
    # |> Ecto.build_assoc(:orders, attrs)
    CPAP.Purchases.create_order(attrs, user)
#    |> Repo.insert!()
  end
end


