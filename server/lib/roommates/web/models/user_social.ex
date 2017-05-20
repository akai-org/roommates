defmodule Roommates.UserSocial do
  use Roommates.Web, :model

  schema "user_socials" do
    field :provider, :string
    field :provider_uid, :string
    belongs_to :user, Roommates.User

    timestamps()
  end

  def changeset(user_social, auth) do
    user_social
    |> cast(%{ provider: Atom.to_string(auth.provider), provider_uid: auth.uid },
      [:provider, :provider_uid])
    |> validate_required([:provider, :provider_uid])
  end
end
