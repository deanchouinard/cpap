defmodule CPAP.Purchases.Reports do
  alias CPAP.Interval
  alias CPAP.Product
  alias CPAP.Repo
  alias CPAP.Purchases.Order
  use Timex

  import Ecto.Query

  def suggested_order(user) do
    products = Repo.all(from p in Product,
                        where: p.user_id == ^user.id,
                        join: i in assoc(p, :interval),
                        preload: [interval: i])
    |> Enum.reject(&no_orders?(&1, user) )
    #|> Repo.preload(:interval)
    |> Enum.map(&last_ordered(&1, user))
    # products_needed = Enum.reject(products, &no_orders?(&1, user) )
    # products_needed = Repo.preload(products_needed, :interval)
    # products_needed = Enum.map(products_needed, &last_ordered(&1, user))
    # IO.inspect products_needed
  end

  def no_orders?(p, user) do
      target_date = Timex.subtract(Timex.now,
        Timex.Duration.from_days(p.interval.months * 30))
      # if order date within interval
      case Repo.all(from o in Order,
                        where: o.user_id == ^user.id,
                        join: i in assoc(o, :items),
                        where: i.product_id == ^p.id,
                        where: o.order_date > ^target_date,
                        preload: [items: i]) do
        [] -> nil
        _ -> true
      end
  end

  # defp add_last_ordered(products, user) do
  #   Enum.map(products, &last_ordered(&1, user))
  # end

  defp last_ordered(p, user) do
    query = from o in Order,
      where: o.user_id == ^user.id,
      join: i in assoc(o, :items),
      where: i.product_id == ^p.id,
      select: o.order_date

    ld = last(query, :order_date) |> Repo.one

    Map.put_new(p, :last_ordered, ld)
  end
end
