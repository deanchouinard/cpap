defmodule CPAP.Web.IntervalTest do
  use CPAP.DataCase

  alias CPAP.Interval

  @valid_attrs %{months: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Interval.changeset(%Interval{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Interval.changeset(%Interval{}, @invalid_attrs)
    refute changeset.valid?
  end
end
