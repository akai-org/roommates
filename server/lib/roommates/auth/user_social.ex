defmodule Roommates.Auth.UserSocial do
  use Ecto.Schema
  import Ecto.Changeset
  alias Roommates.Auth.UserSocial

  schema "user_socials" do
    field :provider, :string
    field :provider_uid, :string
    belongs_to :user, Roommates.Auth.User

    timestamps()
  end

  def changeset(%UserSocial{} = user_social, auth) do
    user_social
    |> cast(%{ provider: Atom.to_string(auth.provider), provider_uid: auth.uid },
      [:provider, :provider_uid])
    |> validate_required([:provider, :provider_uid])
  end
end
