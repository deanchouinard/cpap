defmodule CPAP.Web.ProductViewTest do
  use CPAP.Web.ConnCase, async: true
  import Phoenix.View

  #   @tag :skip
  test "renders index.html", %{conn: conn} do
    products = [%CPAP.Product{id: 1, code: "ONE", desc: "One desc", qty: 1,
              interval: %{months: 1}},
              %CPAP.Product{id: 2, code: "TWO", desc: "Two desc", qty: 2,
              interval: %{months: 3}}]

    content = render_to_string(CPAP.Web.ProductView, "index.html",
                              conn: conn, products: products)
    assert String.contains?(content, "Listing products")
    for product <- products do
      assert String.contains?(content, product.code)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = CPAP.Product.changeset(%CPAP.Product{})
    intervals = [{3, 1}]
    content = render_to_string(CPAP.Web.ProductView, "new.html",
                              conn: conn, changeset: changeset, intervals:
                              intervals)
    assert String.contains?(content, "New product")
  end
end

