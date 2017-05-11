defmodule Roommates.Repo.Migrations.AddUserSocialsTable do
  use Ecto.Migration

  def change do
    create table(:user_socials) do
      add :provider, :string
      add :provider_uid, :string
      add :user_id, references(:users)
      timestamps()
    end
  end
end
