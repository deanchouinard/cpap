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

    products_needed = Enum.reject(products, &no_orders?(&1, user) )
#    Enum.each(products_needed, fn(x) -> IO.puts x.code end)

  end

  def no_orders?(p, user) do
      target_date = Timex.subtract(Timex.now,
        Timex.Duration.from_days(p.interval.months * 30))
      # is there an order that contains the product within Interval time
      case Repo.all(from o in Order,
                        where: o.user_id == ^user.id,
                        join: i in assoc(o, :items),
                        where: i.product_id == ^p.id,
                        where: o.order_date < ^target_date,
                        preload: [items: i]) do
        [] -> nil
        _ -> true
      end
  end

end
