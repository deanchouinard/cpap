defmodule CPAP.Web.UserView do
  use CPAP.Web, :view
  alias CPAP.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end

