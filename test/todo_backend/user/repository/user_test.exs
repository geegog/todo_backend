defmodule TodoBackend.User.Repository.UserTest do
  use TodoBackend.DataCase

  alias TodoBackend.User.Repository.UserRepo

  describe "users" do
    alias TodoBackend.User.Model.User

    @valid_attrs %{email: "some email", name: "some name", phone: "some phone"}
    @update_attrs %{email: "some updated email", name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{email: nil, name: nil, phone: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserRepo.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserRepo.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserRepo.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserRepo.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.phone == "some phone"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserRepo.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.phone == "some updated phone"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserRepo.update_user(user, @invalid_attrs)
      assert user == UserRepo.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserRepo.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserRepo.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserRepo.change_user(user)
    end
  end
end
