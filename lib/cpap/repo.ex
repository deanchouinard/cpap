defmodule CPAP.Repo do
#  use Ecto.Repo, otp_app: :cpap

  def all(CPAP.User) do
    [
      %CPAP.User{id: "1", name: "Dean", username: "deanc", password: "deanc"},
      %CPAP.User{id: "2", name: "Bob", username: "bob", password: "bob"},
      %CPAP.User{id: "3", name: "Sally", username: "sally", password: "sally"}
    ]
  end
  def all(_module), do: []

  def get(module, id) do
    Enum.find all(module), fn map -> map.id == id end
  end

  def get_by(module, params) do
    IO.inspect params
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end

end
