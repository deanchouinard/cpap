defmodule CPAP.IntervalRepoTest do
  use CPAP.DataCase
  alias CPAP.Interval

  test "ascending/1 order by months" do
    user = insert_user()
    Repo.insert(%Interval{months: 1, user_id: user.id})
    Repo.insert(%Interval{months: 3, user_id: user.id})
    Repo.insert(%Interval{months: 6, user_id: user.id})

    query = Interval |> Interval.ascending()
    query = from i in query, select: i.months
    assert Repo.all(query) == [1, 3, 6]
  end
end

