defmodule CPAP.Web.PageView do
  use CPAP.Web, :view
  use Timex

  def today, do: Timex.local |> Timex.format!("{M}-{D}-{YYYY}")

end
