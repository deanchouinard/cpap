defmodule CPAP.Web.Views.Helpers do

  def todays_date, do: Date.utc_today |> Date.to_erl

end

