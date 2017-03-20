defmodule CPAP.Web.ProductView do
  use CPAP.Web, :view

  def i_months(id) do
    CPAP.Interval.id_to_months(id)
  end

end
