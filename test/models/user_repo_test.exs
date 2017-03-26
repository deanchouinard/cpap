defmodule CPAP.UserRepoTest do
  use CPAP.DataCase
  alias CPAP.User

  @valid_attrs %{name: "A user", username: "eva", password: "temppass"}

  test "create unique constraint on username to error" do
    insert_user(%{username: "eric"})
    attrs = Map.put(@valid_attrs, :username, "eric")
    changeset = User.registration_changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert username: {"has already been taken", []} in changeset.errors
  end
end

