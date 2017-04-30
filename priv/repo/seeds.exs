# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CPAP.Repo.insert!(%CPAP.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CPAP.Repo
alias CPAP.Interval
alias CPAP.Product
alias CPAP.User
alias CPAP.Purchases.Order
alias CPAP.Purchases.Item
use Timex

defmodule SeedUtil do
  def interval(months) do
    %CPAP.Interval{id: id} = Repo.get_by!(CPAP.Interval, months: months)
    id
  end

  def product(code) do
    %Product{id: id} = Repo.get_by!(Product, code: code)
    id
  end
end

user_params = %{name: "Dean", username: "dean", password: "temppass"}
changeset = User.registration_changeset(%User{}, user_params)
user = Repo.get_by(User, username: "dean") ||
   Repo.insert!(changeset)

for interval <- [1, 3, 6] do
  Repo.get_by(CPAP.Interval, months: interval) ||
    Repo.insert!(%CPAP.Interval{months: interval, user_id: user.id})
end

products = [ ["FILTERS", "Machine filters; 2pk", 2, 1],
  ["TUBE", "Heated tube", 1, 3],
  ["MASKS", "Mask/cushion", 1, 1],
  ["TUB", "Water tub", 1, 6],
  ["HGEAR", "Head gear w/ mask", 1, 6]]

for [code, desc, qty, months] = _product <- products do
  Repo.get_by(Product, code: code) ||
    Repo.insert!(%Product{code: code, desc: desc, qty: qty,
      user_id: user.id, interval_id: SeedUtil.interval(months)})
end

orders = [ ~D[2010-04-17], Timex.local |> DateTime.to_date() ]

for order_date = _order <- orders do
  Repo.get_by(Order, order_date: order_date) ||
    Repo.insert!(%Order{order_date: order_date, user_id: user.id})
end

order = Repo.get_by(Order, order_date: ~D[2010-04-17])

items = [ [1, "TUBE"], [1, "FILTERS"] ]
for [qty, code] = _item <- items do
  Repo.get_by(Item, product_id: SeedUtil.product(code)) ||
    Repo.insert!(%Item{qty: qty, order_id: order.id, user_id: user.id,
      product_id: SeedUtil.product(code)})
end

