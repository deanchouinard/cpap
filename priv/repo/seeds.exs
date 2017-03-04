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

defmodule SeedUtil do
  def interval(months) do
    %Interval{id: id} = Repo.get_by!(Interval, months: months)
    id
  end
end

user_params = %{name: "Dean", username: "dean", password: "temppass"}
changeset = User.registration_changeset(%User{}, user_params)
user = Repo.get_by(User, username: "dean") ||
   Repo.insert!(changeset)

for interval <- [1, 3, 6] do
  Repo.get_by(Interval, months: interval) ||
    Repo.insert!(%Interval{months: interval, user_id: user.id})
end

products = [ ["FILTERS", "Machine filters; 2pk", 2, 1],
  ["TUBE", "Heated tube", 1, 3],
  ["MASKS", "Mask/cushion", 1, 1]]

for [code, desc, qty, months] = _product <- products do
  Repo.get_by(Product, code: code) ||
    Repo.insert!(%Product{code: code, desc: desc, qty: qty,
      user_id: user.id, interval_id: SeedUtil.interval(months)})
end

