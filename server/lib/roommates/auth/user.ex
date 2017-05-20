defmodule Roommates.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Roommates.Auth.User

  schema "users" do
    field :name, :string
    field :email, :string
    has_many :user_socials, Roommates.Auth.UserSocial

    timestamps()
  end

  def registration_changeset(%User{} = user, auth) do
    user
    |> cast(Map.from_struct(auth.info), [:name, :email])
    |> validate_required([:name])
    |> unique_constraint(:email)
  end
end
