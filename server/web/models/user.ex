defmodule Roommates.User do
  use Roommates.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    has_many :user_socials, Roommates.UserSocial

    timestamps()
  end

  def registration_changeset(user, auth) do
    user
    |> cast(Map.from_struct(auth.info), [:name, :email])
    |> validate_required([:name])
    |> unique_constraint(:email)
  end
end
