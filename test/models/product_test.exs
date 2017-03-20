defmodule CPAP.Web.ProductTest do
  use CPAP.Web.ModelCase

  alias CPAP.Product

  @valid_attrs %{code: "some content", desc: "some content", qty: 1,
                interval_id: 1}
  @invalid_attrs %{code: ""}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
